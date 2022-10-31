import { FastifyInstance, FastifyRequest } from 'fastify';
import crypto from 'crypto';
import { NonceCache } from './nonce-cache';
import fastifySensible from '@fastify/sensible';
import fp from 'fastify-plugin';

type Options = {
  sharedSecret: string;
  allowedTimeDrift?: number;
};

const extractHeader = (request: FastifyRequest, header: string) => {
  const value = request.headers[header];
  console.log(header, value);
  if (typeof value !== 'string') {
    throw new Error(`Header ${header} is not a string`);
  }
  return value;
};

const security = fp(
  async (
    fastify: FastifyInstance,
    { sharedSecret, allowedTimeDrift = 30 }: Options
  ) => {
    const nonceCache = new NonceCache(allowedTimeDrift * 2);
    fastify.register(fastifySensible);

    fastify.decorateRequest<string>('bodyText', '');
    fastify.addContentTypeParser(
      'application/json',
      { parseAs: 'string' } as any,
      (req: FastifyRequest, body: string, done) => {
        try {
          var json = JSON.parse(body);
          req.bodyText = body;
          done(null, json);
        } catch (err: any) {
          err.statusCode = 400;
          done(err, undefined);
        }
      }
    );

    fastify.addContentTypeParser(
      '*',
      { parseAs: 'string' } as any,
      (req: FastifyRequest, body: string, done) => {
        req.bodyText = body;
        done(null, body);
      }
    );

    fastify.addHook('preHandler', async (request, reply) => {
      const validator = extractHeader(request, 'x-validator');
      const timestamp = extractHeader(request, 'x-timestamp');
      const nonce = extractHeader(request, 'x-nonce');
      const host = extractHeader(request, 'host');
      const requestParams = [
        request.method,
        request.protocol,
        host,
        request.raw.url,
        request.bodyText,
      ];
      const validationParams = [timestamp, nonce, ...requestParams];
      const parsedTimestamp = parseInt(timestamp, 10);
      const now = new Date().getTime() / 1000;

      if (Math.abs(now - parsedTimestamp) > allowedTimeDrift) {
        return reply.unauthorized('invalid timestamp');
      }

      if (nonceCache.has(nonce)) {
        return reply.unauthorized('invalid nonce');
      }

      nonceCache.add(nonce);

      const hash = crypto.createHmac('sha256', sharedSecret);
      const data = validationParams
        .map((a) => Buffer.from(a || '').toString('base64'))
        .join('|');
      const digest = hash.update(data).digest('base64');

      if (digest !== validator) {
        return reply.unauthorized('invalid validator');
      }
    });
  }
);

export { security };
