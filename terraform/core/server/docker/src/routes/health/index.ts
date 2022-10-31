import { FastifyInstance } from 'fastify';

const attachHealthRoutes = (fastify: FastifyInstance) => {
  fastify.register(
    async (instance) => {
      instance.get('/', async () => {
        return { status: 'ok' };
      });
    },
    {
      prefix: '/health',
    }
  );
};

export { attachHealthRoutes };
