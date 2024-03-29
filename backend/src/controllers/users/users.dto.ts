import { UserRole } from '@/db/interface/user.interface';
import { IsString, MinLength, IsEnum } from 'class-validator';

export class CreateUserDto {
  @IsString()
  @MinLength(3, { message: 'Username must be at least 3 characters long' })
  readonly username: string;

  @IsEnum(UserRole)
  readonly role: string;
}
