import { NextResponse } from "next/server";

export async function POST(req: Request) {
  try {
    const body = await req.json();
    const { email, password } = body;

    if (!email || !password) {
      return NextResponse.json(
        { error: "Email and password are required" },
        { status: 400 }
      );
    }

    // Mock successful login
    console.log(`[AUTH] User logged in: ${email}`);
    
    return NextResponse.json(
      { 
        message: "Login successful", 
        token: "mock-jwt-token-12345",
        user: { name: "Alex", email: email }
      },
      { status: 200 }
    );
  } catch (error) {
    console.error("Login Error:", error);
    return NextResponse.json(
      { error: "Failed to process login." },
      { status: 500 }
    );
  }
}