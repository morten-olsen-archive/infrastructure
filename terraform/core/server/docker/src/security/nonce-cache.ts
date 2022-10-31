class NonceCache {
  private cache: Map<string, number> = new Map();
  private readonly maxAge: number;

  constructor(maxAge: number) {
    this.maxAge = maxAge * 1000;
  }

  public cleanup(): void {
    const now = Date.now();
    for (const [nonce, timestamp] of this.cache) {
      if (now - timestamp > this.maxAge) {
        this.cache.delete(nonce);
      }
    }
  }

  public add(nonce: string): void {
    this.cache.set(nonce, Date.now());
    this.cleanup();
  }

  public has(nonce: string): boolean {
    const timestamp = this.cache.get(nonce);
    if (timestamp === undefined) {
      return false;
    }

    if (Date.now() - timestamp > this.maxAge) {
      this.cache.delete(nonce);
      return false;
    }

    return true;
  }
}

export { NonceCache };
