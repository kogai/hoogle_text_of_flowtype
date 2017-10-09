declare class A<T> {
  a(x: string): number;
  b(x: T): T[];
  d<U>(x: U): U[];
  f: string => number;
}
