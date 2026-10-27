import { randomInt } from "node:crypto";

// Unbiased Fisher–Yates shuffle. Returns a new array.
// Runs at build time, so each deployment gets a new order.
export function shuffle<T>(items: readonly T[]): T[] {
  const result = [...items];
  for (let i = result.length - 1; i > 0; i--) {
    const j = randomInt(i + 1);
    [result[i], result[j]] = [result[j], result[i]];
  }
  return result;
}
