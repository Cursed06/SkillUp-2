import { GoogleGenerativeAI } from "@google/generative-ai";
import { NextResponse } from "next/server";

// Ensure your GEMINI_API_KEY is in the .env.local file
console.log("API KEY LOADED:", process.env.GEMINI_API_KEY ? "YES" : "NO");
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY!);

export async function POST(req: Request) {
  try {
    const { jobTitle, cvContent } = await req.json();

    // 1. We configure the model to natively return pure JSON
    const model = genAI.getGenerativeModel({ 
      model: "gemini-2.5-flash",
      generationConfig: { responseMimeType: "application/json" } 
    });

    // 2. We provide the strict schema we want inside the prompt
    const prompt = `You are an expert tech recruiter. Evaluate this CV against the target job: "${jobTitle}".
    
    Using this JSON schema:
    {
      "matchScore": number,
      "skillGaps": Array<string>,
      "cvFeedback": Array<string>
    }

    Return a valid JSON object.
    
    CV Text:
    ${cvContent.substring(0, 5000)}
    `;

    const result = await model.generateContent(prompt);
    const responseText = result.response.text();
    
    // 3. Because we used responseMimeType, we can safely parse it directly
    const parsedData = JSON.parse(responseText);

    return NextResponse.json(parsedData);

  } catch (error) {
    // 4. If it fails, this will print the EXACT reason in your Next.js terminal
    console.error("🔥 ACTUAL ERROR:", error);
    return NextResponse.json({ error: "Failed to analyze document." }, { status: 500 });
  }
}