import { NextResponse } from "next/server";

export async function POST(req: Request) {
  try {
    const body = await req.json();
    const { name, email, university, password } = body;

    if (!email || !password) {
      return NextResponse.json(
        { error: "Please fill in all required fields" },
        { status: 400 }
      );
    }

    // Mock successful registration
    console.log(`[AUTH] New user registered: ${name} from ${university}`);

    return NextResponse.json(
      { 
        message: "Registration successful", 
        token: "mock-jwt-token-12345",
        user: { name: name, email: email }
      },
      { status: 201 }
    );
  } catch (error) {
    console.error("Register Error:", error);
    return NextResponse.json(
      { error: "Failed to process registration." },
      { status: 500 }
    );
  }
}