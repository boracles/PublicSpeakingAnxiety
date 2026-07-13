using System;

// 지후님이 보내줄 JSON 구조와 1:1로 매칭될 데이터 구조입니다.
[Serializable]
public class PresentationConfigData
{
    public string pdf_url;      // PDF 파일의 절대 경로
    public int total_pages;     // 전체 페이지 수 (현재 2개)
}