import { Types } from 'mongoose';

export default function isValidId(_id: string): boolean {
  return Types.ObjectId.isValid(_id);
}
