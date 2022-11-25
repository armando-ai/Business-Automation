import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { Transport } from '@nestjs/microservices';
import { CalendarModule } from './calendar.module';

async function bootstrap() {
  const app = await NestFactory.create(CalendarModule);
  const config = app.get<ConfigService>(ConfigService);
  const port = config.get<number>('port');
  const internal_port = config.get<number>('internal_port');
  const host = config.get<string>('host');
  app.connectMicroservice({
    transport: Transport.TCP,
    options: {
      host: host,
      port: internal_port
    }
  });
  await app.startAllMicroservices();
  await app.listen(port);
}
bootstrap();
