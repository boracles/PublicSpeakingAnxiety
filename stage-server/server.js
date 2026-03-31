const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
const OpenAI = require("openai");

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

const client = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

app.post("/infer-stage", async (req, res) => {
  try {
    const {
      current_text = "",
      recent_context = "",
      elapsed_time_sec = 0,
      previous_stage = "Unknown",
      slide_title = "Unknown Slide",
    } = req.body;

    const response = await client.responses.create({
      model: "gpt-4.1-mini",
      input: [
        {
          role: "system",
          content: [
            {
              type: "input_text",
              text:
                "You are a presentation stage classifier. " +
                "Classify the current presentation stage into exactly one of: " +
                "Orientation, Rationale, Framework, Purpose, Methods, Results, Implication, Termination. " +
                "Return only JSON matching the schema."
            }
          ]
        },
        {
          role: "user",
          content: [
            {
              type: "input_text",
              text: JSON.stringify({
                current_text,
                recent_context,
                elapsed_time_sec,
                previous_stage,
                slide_title
              })
            }
          ]
        }
      ],
      text: {
        format: {
          type: "json_schema",
          name: "stage_inference",
          schema: {
            type: "object",
            additionalProperties: false,
            properties: {
              stage: {
                type: "string",
                enum: [
                  "Orientation",
                  "Rationale",
                  "Framework",
                  "Purpose",
                  "Methods",
                  "Results",
                  "Implication",
                  "Termination"
                ]
              },
              confidence: {
                type: "number"
              },
              reason: {
                type: "string"
              }
            },
            required: ["stage", "confidence", "reason"]
          },
          strict: true
        }
      }
    });

    const outputText = response.output_text;
    const parsed = JSON.parse(outputText);

    res.json(parsed);
  } catch (error) {
    console.error(error);
    res.status(500).json({
      error: "stage_inference_failed",
      detail: error.message
    });
  }
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Stage server running on port ${port}`);
});