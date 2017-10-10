declare class A<T> {
  a(x: string): number;
  b(x: T): T[];
  c<U>(x: U): U[];
  d: string => number;
}
