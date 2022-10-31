import { Service } from 'typedi';

type Service = any;

@Service()
class ServiceService {
  public list = async (namespace: string) => {};

  public get = async (namespace: string, name: string) => {};

  public set = async (namespace: string, name: string, service: Service) => {};

  public remove = async (namespace: string, name: string) => {};
}

export { ServiceService };
