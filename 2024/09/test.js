const { readFile } = require("fs/promises");

const extractDiskMap = (input) => {
  const diskMap = [];
  let id = 0;

  input.split("").forEach((num, i) => {
    if (i % 2 === 0) {
      for (let j = 0; j < num; j++) {
        diskMap.push(id);
      }
      id++;
    } else {
      for (let k = 0; k < num; k++) {
        diskMap.push(".");
      }
    }
  });

  return diskMap;
};

const moveBlocks = (diskMap) => {
  const movedBlocks = [];
  const diskMapNumbers = diskMap.filter((e) => !isNaN(e));

  let movedBlocksCount = 0;

  for (let i = 0; i < diskMap.length; i++) {
    const char = diskMap[i];

    if (char !== ".") {
      movedBlocks.push(char);
    } else {
      movedBlocks.push(diskMapNumbers.pop());
      movedBlocksCount++;
    }
  }

  return movedBlocks.slice(0, movedBlocks.length - movedBlocksCount);
};

const calculateChecksum = (movedBlocks) => {
  let sum = 0;

  for (let i = 0; i < movedBlocks.length; i++) {
    sum += movedBlocks[i] * i;
  }

  return sum;
};

const main = async () => {
  try {
    const input = (await readFile("input.txt", "utf-8")).trim();

    const diskMap = extractDiskMap(input);

    // console.log(diskMap[diskMap.length - 1]);

    const movedBlocks = moveBlocks(diskMap);
    console.log(movedBlocks[movedBlocks.length - 1]);

    const result = calculateChecksum(movedBlocks);

    console.log(result);
  } catch (err) {
    console.error(err);
  }
};

main();
