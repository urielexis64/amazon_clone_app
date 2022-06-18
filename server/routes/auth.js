const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/user");
const auth = require("../middlewares/auth");
const authRouter = express.Router();

authRouter.post("/api/signup", async (req, res) => {
	try {
		const {name, email, password} = req.body;

		const existingUser = await User.findOne({email});
		if (existingUser) {
			return res.status(400).json({message: "User already exists"});
		}

		const hashedPassword = await bcrypt.hash(password, 8);

		let user = new User({
			name,
			email,
			password: hashedPassword,
		});

		user = await user.save();
		res.json(user);
	} catch (err) {
		res.status(500).json({error: err.message});
	}
});

authRouter.post("/api/signin", async (req, res) => {
	try {
		const {email, password} = req.body;

		console.log(email, password);

		if (!email || !password) {
			return res.status(400).json({message: "Please provide email and password"});
		}

		const user = await User.findOne({email});
		if (!user) {
			return res.status(400).json({message: "User does not exists"});
		}

		const isPasswordValid = await bcrypt.compare(password, user.password);
		if (!isPasswordValid) {
			return res.status(400).json({message: "Invalid password"});
		}

		const token = jwt.sign({id: user._id}, process.env.JWT_SECRET);
		res.json({token, ...user._doc});
	} catch (err) {
		res.status(500).json({error: err.message});
	}
});

authRouter.post("/validateToken", async (req, res) => {
	try {
		const token = req.header("x-auth-token");
		if (!token) {
			return res.res.json(false);
		}

		const decoded = jwt.verify(token, process.env.JWT_SECRET);

		if (!decoded) return res.json(false);

		const user = await User.findById(decoded.id);
		if (!user) {
			return res.json(false);
		}

		res.json(true);
	} catch (err) {
		res.status(500).json({error: err.message});
	}
});

// get user data
authRouter.get("/", auth, async (req, res) => {
	try {
		const user = await User.findById(req.user);
		res.json({...user._doc, token: req.token});
	} catch (err) {
		res.status(500).json({error: err.message});
	}
});

module.exports = authRouter;
