const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
	name: {
		type: String,
		required: true,
		trim: true,
	},
	email: {
		type: String,
		required: true,
		trim: true,
		validate: {
			validator: (value) => {
				const regex =
					/^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
				return value.match(regex);
			},
			message: "Invalid email format",
		},
	},
	password: {
		type: String,
		required: true,
		validate: {
			validator: (value) => {
				return value.length > 6;
			},
			message: "Please enter a password with at least 6 characters",
		},
	},
	address: {
		type: String,
		default: "",
	},
	type: {
		type: String,
		default: "user",
	},
});

const User = mongoose.model("User", userSchema);

module.exports = User;
