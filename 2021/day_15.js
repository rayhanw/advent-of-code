const fs = require("fs");

let file = fs.readFileSync("day_15.txt", "utf-8").split("\n");

file = file
  .slice(0, file.length - 1)
  .map((num) => num.split("").map((nu) => parseInt(nu)));

// console.table(file);
function min(x, y) {
  if (x < y) return x;
  else return y;
}

// Returns cost of minimum cost path
// from (0,0) to (m, n) in mat[R][C]
function minPathSum(cost, m, n) {
  if (n < 0 || m < 0) return Number.MAX_VALUE;
  else if (m == 0 && n == 0) return cost[m][n];
  else {
    console.log(`[${m}][${n}]`);

    return (
      cost[m][n] + min(minPathSum(cost, m - 1, n), minPathSum(cost, m, n - 1))
    );
  }
}

var cost = [
  [4, 7, 6],
  [2, 8, 7],
  [4, 6, 8],
];

console.log(minPathSum(cost, 2, 2));
