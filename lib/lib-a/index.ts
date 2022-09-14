import { keyBy } from "lodash";

const hardcoded = [
  { id: 1, value: "a" },
  { id: 2, value: "b" },
  { id: 3, value: "c" },
  { id: 4, value: "d" },
  { id: 5, value: "e" },
];

export default function () {
  return keyBy(hardcoded, (elem) => elem.id);
}
