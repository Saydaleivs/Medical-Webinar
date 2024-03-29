import * as mongoose from 'mongoose';
import { UserRole } from '../interface/user.interface';

export const UserSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true },
  role: {
    type: String,
    enum: [UserRole.Doctor, UserRole.Patient],
    required: true,
  },
});
