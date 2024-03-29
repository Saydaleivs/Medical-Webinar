import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { WebinarsController } from '@/controllers/webinars/webinars.controller';
import { WebinarsService } from '@/services/webinars/webinar.service';
import { WebinarSchema } from '@/db/schema/webinar.schema';
import { UserSchema } from '@/db/schema/user.schema';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: 'Webinar', schema: WebinarSchema }]),
    MongooseModule.forFeature([{ name: 'User', schema: UserSchema }]),
  ],
  controllers: [WebinarsController],
  providers: [WebinarsService],
})
export class WebinarsModule {}
