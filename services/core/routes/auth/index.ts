import { User } from "@prisma/client";
import * as bcrypt from "bcrypt";
import dotenv from "dotenv";
import { Request, Router } from "express";
import * as jsonwebtoken from "jsonwebtoken";
import Prisma from "../../prisma/index.js";
import SignInRequestValidator, { SignInRequest } from "../../validators/auth/sign-in-request.validator.js";
import SignUpRequestValidator, { SignUpRequest } from "../../validators/auth/sign-up-request.validator.js";

dotenv.config();

const JWT_SECRET_KEY = process.env.JWT_SECRET_KEY;
if (!JWT_SECRET_KEY) {
  throw new Error("Error: Missing JWT Secret Key");
}

const AuthRouter = Router();

// Sign-Up Route
AuthRouter.post("/sign-up", async (req: Request<null, { user: User } | { error: "Invalid Request Body"; trace: any }, SignUpRequest, null>, res) => {
  const request = req.body;

  const validation = SignUpRequestValidator.safeParse(request);
  if (!validation.success) {
    console.error(`Validation Error: ${validation.error}`);
    return res.status(400).send({ error: "Invalid Request Body", trace: validation.error });
  }

  // Hash the Password
  const passwordHash = bcrypt.hashSync(request.password, 12);

  // Create the User
  const user = await Prisma.user.create({
    data: {
      name: request.name,
      email: request.email,
      passwordHash: passwordHash,
      role: request.role,
    },
  });

  user.passwordHash = "";
  return res.status(200).send({ user });
});

// Sign-In Route
AuthRouter.post("/sign-in", async (req, res) => {
    try {
        const request = req.body;
        const validation = SignInRequestValidator.safeParse(request);
        if (!validation.success) {
            console.error(`Validation Error: ${validation.error}`);
            return res.status(400).send({ error: "Invalid Request Body", trace: validation.error });
        }

        // Find user by email
        const user = await Prisma.user.findUnique({ where: { email: request.email } });
        if (!user) {
            return res.status(401).send({ error: "Invalid Credentials" });
        }

        // Check if the Password is Correct
        const passwordMatch = bcrypt.compareSync(request.password, user.passwordHash);
        if (!passwordMatch) {
            return res.status(401).send({ error: "Invalid Credentials" });
        }

        // Remove password hash from response
        user.passwordHash = "";

        // ✅ FIX: Changed email: user.role to email: user.email
        const payload = { id: user.id, email: user.email, role: user.role };
        const token = jwt.sign(payload, JWT_SECRET_KEY, { expiresIn: "1h" });

        return res.status(200).send({ user, token });
    } catch (error) {
        console.error("Sign-in error:", error);
        return res.status(500).send({ error: "Internal server error" });
    }
});

export default AuthRouter;
