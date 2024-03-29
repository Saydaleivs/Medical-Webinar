import { Document } from 'mongoose';

export interface User extends Document {
  username: string;
  role: UserRole;
}

export enum UserRole {
  Doctor = 'Doctor',
  Patient = 'Patient',
}
