import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { DatabaseModule } from '@/db/database.module';
import { UsersModule } from '@/modules/users.module';
import configuration from '@/configs/configuration';
import { WebinarsModule } from './webinars.module';
import { GridFsModule } from '@/gridfs/gridfs.module';

@Module({
  imports: [
    DatabaseModule,
    GridFsModule,
    WebinarsModule,
    UsersModule,
    ConfigModule.forRoot({ load: [configuration] }),
  ],
})
export class AppModule {}
