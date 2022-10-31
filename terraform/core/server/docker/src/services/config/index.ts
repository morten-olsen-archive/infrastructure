import { join } from 'path';

class ConfigService {
  #data: string;

  constructor() {
    this.#data = join(process.cwd(), 'data');
  }

  public get data() {
    return this.#data;
  }
}

export { ConfigService };
