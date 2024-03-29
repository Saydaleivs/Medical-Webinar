import { Controller, Get, Post, Body, Param } from '@nestjs/common';
import { UsersService } from '@/services/users/users.service';
import { User } from '@/db/interface/user.interface';
import { CreateUserDto } from './users.dto';
import isValidId from '@/utils/isValidId.util';

@Controller('user')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get()
  async findAll(): Promise<User[]> {
    return this.usersService.findAll();
  }

  @Get(':id')
  async checkAuth(@Param() id: string): Promise<User> {
    return this.usersService.findOne(id);
  }

  @Post()
  async create(@Body() createUserDto: CreateUserDto): Promise<User> {
    return await this.usersService.create(createUserDto);
  }
}
