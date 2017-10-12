import type { EventEmitter } from 'events';

declare module 'my-module' {
  declare function f(x: string): number;
  declare function g<T>(x: T): T[];

  declare module.exports: {
    f: typeof f,
    g: typeof g,
  };
}
