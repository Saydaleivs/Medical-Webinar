import { IsString, IsNotEmpty, IsDateString } from 'class-validator';

export class CreateWebinarDto {
  @IsNotEmpty()
  @IsString()
  title: string;

  @IsNotEmpty()
  @IsDateString()
  date: string;

  @IsNotEmpty()
  @IsString()
  authorId: string;

  @IsNotEmpty()
  image: string;
}
