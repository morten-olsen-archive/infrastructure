import { Service } from 'typedi';

type Core = any;

@Service()
class CoreService {
  public list = async () => {};

  public get = async (namespace: string) => {};

  public set = async (namespace: string, core: Core) => {};

  public remove = async (namespace: string) => {};
}

export { CoreService };
