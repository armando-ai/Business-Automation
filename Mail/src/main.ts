import { NestFactory } from '@nestjs/core';
import { RmqService } from 'libs/common/src/rmq/rmq.service';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const rmqService = app.get<RmqService>(RmqService);
  app.connectMicroservice(rmqService.getOptions('USERS'));
  app.connectMicroservice(rmqService.getOptions('CALENDAR'));
  await app.startAllMicroservices(); 
}
bootstrap();
