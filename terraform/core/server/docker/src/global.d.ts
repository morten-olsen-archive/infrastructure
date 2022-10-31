import 'fastify';
import { ContainerInstance } from 'typedi';

declare module 'fastify' {
  export interface FastifyRequest {
    container: ContainerInstance;
    bodyText: string;
  }
}
