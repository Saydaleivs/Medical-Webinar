import configuration from '@/configs/configuration';
import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';

@Module({
  imports: [MongooseModule.forRoot(configuration().database.uri)],
})
export class DatabaseModule {}
