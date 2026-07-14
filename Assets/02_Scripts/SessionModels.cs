using System;
using System.Collections.Generic;

[Serializable]
public class SessionData
{
    // JSON의 1234 내부에 있는 항목들
    public string created_at;
    public Page1BasicInfo page_1; // JSON의 "page_1"과 일치
    public Page2Data page_2; 
    public Page3AudienceInfo page_3;
}

[Serializable]
public class Page1BasicInfo
{
    public int duration_minutes;
    public string environment_type;
    public int qa_count;
    public string presentation_title;
}

[Serializable]
public class Page2Data
{
    public string presentation_script_content;
    public SlideImage slide_image;
}

[Serializable]
public class SlideImage
{
    public int image_len;
    public List<string> image_urls;
}

[Serializable]
public class Page3AudienceInfo
{
    public int audience_scale; // JSON의 audience_scale
    public string audience_expertise; // JSON의 audience_expertise (이 이름이어야 함!)
    public string audience_interest;  // JSON의 audience_interest (이 이름이어야 함!)
}