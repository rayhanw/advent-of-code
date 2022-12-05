const fs = require('fs')

// part 1
function part1() {
    const data = fs.readFileSync('./day_8.txt', 'utf-8').split('\r\n').join().split(' | ').join().split(',')
    let outputSignals = data.filter((x,index) => {
        return (index % 2 != 0)
    }).join()
    .split(/,| /)
    .filter(x => x.length == 2 || x.length == 4
        || x.length == 3 || x.length == 7)
}
// part1()



// part 2

//0 : top, topLeft, topRight, bottomLeft, bottomRight, bottom
//1 : topRight, bottomRight
//2 : top, topRight, mid, bottomLeft, bottom
//3 : top, topRight, mid, bottomRight, bottom
//4 : topLeft, topRight, mid, bottomRight
//5 : top, topLeft, mid, bottomRight, bottom
//6 : top, topLeft, mid, bottomLeft, bottomRight, bottom
//7 : top, topRight, bottomRight
//8 : top, topLeft, topRight, mid, bottomLeft, bottomRight, bottom
//9 : top, topLeft, topRight, mid, bottomRight, bottom

// unique : 1,4,7,8
// same length: 2-3-5, 0-6-9
function part2() {
    const data = fs.readFileSync('./day_8.txt', 'utf-8').split('\r\n').join().split(' | ').join().split(',')
    console.log(data);
    let inputSignals = data.filter((x,index) => {
        return (index % 2 == 0)
    }).join()
    .split(/,| /)

    let outputSignals = data.filter((x,index) => {
        return (index % 2 != 0)
    }).join()
    .split(/,| /)


    let start_idx = 0
    let end_idx = 10
    let sum = 0;

    for (let i = 0; i < inputSignals.length / 10; i++) {
        let signalPattern = {
            "top" : undefined,
            "topLeft" : undefined,
            "topRight": undefined,
            "mid" : undefined,
            "bottomLeft" : undefined,
            "bottomRight" : undefined,
            "bottom" : undefined
        }
    
        let arr = inputSignals.slice(start_idx, end_idx);
        let one = arr.filter(x => x.length == 2).toString().split('')
        let seven = arr.filter(x => x.length == 3).toString().split('');
        let four = arr.filter(x => x.length == 4).toString().split('');
        let lengthFives = arr.filter(x => x.length == 5)
        lengthFives.forEach((x,index) => lengthFives[index] = x.split(''))
        let lengthSixes = arr.filter(x => x.length == 6)
        lengthSixes.forEach((x,index) => lengthSixes[index] = x.split(''))
        let eight = arr.filter(x => x.length == 7).toString().split('')

        let two
        let three
        let five
        let zero
        let six
        let nine

        // length 2 => 1
        signalPattern.topRight = one
        signalPattern.bottomRight = one

        // length 3 => 7
        signalPattern.top = seven.filter(x => !one.includes(x))

        // length 4 => 4
        signalPattern.topLeft = four.filter(x => !one.includes(x))
        signalPattern.mid = four.filter(x => !one.includes(x))

        // length 5 == 2 || 3 || 5
        for (let j = 0; j < lengthFives.length; j++) {
            if (lengthFives[j].includes(signalPattern.topRight[0]) && 
            lengthFives[j].includes(signalPattern.topRight[1])) {
                // digit 3
                three = lengthFives[j]
            } else if (lengthFives[j].includes(signalPattern.topLeft[0]) &&
            lengthFives[j].includes(signalPattern.topLeft[1])) {
                // digit 5
                five = lengthFives[j]
            } else {
                //digit 2
                two = lengthFives[j]
            }
        }

        lengthSixes.forEach(signal => {
            if (!(signal.includes(signalPattern.topRight[0]) && signal.includes(signalPattern.topRight[1]))) {
                six = signal; // digit 6
            }
        })
        lengthSixes.splice(lengthSixes.indexOf(six), 1) // remove from array


        let chars = ['a','b','c','d','e','f','g']

        // union topRight, bottomRight, top, topLeft, mid
        let filterFrom = [...signalPattern.topRight, 
            ...signalPattern.bottomRight, 
            ...signalPattern.top,
            ...signalPattern.topLeft, 
            ...signalPattern.mid]

        let removedDuplicates = [...new Set(filterFrom)]

        // find digits 0 and 9
        let newArr = chars.filter(x => !removedDuplicates.includes(x))

        lengthSixes.forEach((x,index) => {
            if (x.includes(newArr[0]) && x.includes(newArr[1])) {
                zero = lengthSixes.splice(index,1).flat()
            }
        })
      
        if (lengthSixes.length == 1) {
            nine = lengthSixes.map(x => x).flat()
        }

        // top done
        // topLeft 0,4,5,6,8,9
        signalPattern.topLeft = findIntersection(zero,four,five,six,eight,nine)

        // topRight 0,1,2,3,4,7,8,9
        signalPattern.topRight = findIntersection(zero,one,two,three,four,seven,eight,nine)

        // mid 2,3,4,5,6,8,9
        signalPattern.mid = findIntersection(two,three,four,five,six,eight,nine)

        // bottomLeft 0,2,6,8
        signalPattern.bottomLeft = findIntersection(zero, two, six, eight)

        // bottomRight 0,1,3,4,5,6,7,8,9
        signalPattern.bottomRight = findIntersection(zero,one,three,four,five,six,seven,eight,nine)

        // bottom 0,2,3,5,6,8,9
        signalPattern.bottom = findIntersection(zero,two,three,five,six,eight,nine)

        
        while(!allSidesHoldsOneLetter(signalPattern)) {
            let lettersDone = []
            let keysNotDone = []
            for (let key in signalPattern) {
                if (signalPattern[key].length == 1) {
                    lettersDone.push(signalPattern[key])
                } else keysNotDone.push(key)
                lettersDone = lettersDone.flat()
    
            }

            for (let j = 0; j < keysNotDone.length; j++) {
                signalPattern[keysNotDone[j]] = signalPattern[keysNotDone[j]]
                                                .filter(x => !lettersDone.includes(x))
            }
            keysNotDone.forEach(key => {
                if (signalPattern[key].length == 1) {
                    keysNotDone.splice(key,1)
                    lettersDone.push(signalPattern[key].toString())
                }
            })
        }

        output = calculate(signalPattern, outputSignals.splice(0,4))
        sum += parseInt(output)
        start_idx += 10
        end_idx += 10
        console.log(signalPattern)
        console.log(displayDigitPattern(signalPattern))
        console.log('--------------------')

    }
    console.log(sum)
    
    function displayDigitPattern(signalPattern) {  
        let str = ""

        return str.concat(` ${signalPattern.top}${signalPattern.top}${signalPattern.top}${signalPattern.top}\n`)
        .concat(`${signalPattern.topLeft}    ${signalPattern.topRight}\n`)
        .concat(`${signalPattern.topLeft}    ${signalPattern.topRight}\n`)
        .concat(` ${signalPattern.mid}${signalPattern.mid}${signalPattern.mid}${signalPattern.mid} \n`)
        .concat(`${signalPattern.bottomLeft}    ${signalPattern.bottomRight}\n`)
        .concat(`${signalPattern.bottomLeft}    ${signalPattern.bottomRight}\n`)
        .concat(` ${signalPattern.bottom}${signalPattern.bottom}${signalPattern.bottom}${signalPattern.bottom} `)
    }

    function findIntersection() {
        let merge = [...arguments],
            result = merge.reduce((a, b) => a.filter(c => b.includes(c)));
        return result
    }

    function allSidesHoldsOneLetter(signalPattern) {
        for (let key in signalPattern) {
            if (signalPattern[key].length > 1) return false;
        }
        return true;
    }

    function calculate(signalPattern, outputArr) {
        let output = '';
        outputArr.forEach(x => {
            switch(x.length) {
                case 2 : output = output.concat('1'); return;
                case 3 : output = output.concat('7'); return;
                case 4 : output = output.concat('4'); return;
                case 5 : {
                    let digit = {

                    }
                    for (let i = 0; i < x.length; i++) {
                        let char = x.charAt(i)
                        for (let key in signalPattern) {
                            if (char == signalPattern[key]) {
                                digit[key] = true;
                            }
                        }
                    }
                    //digit 3
                    if ('top' in digit &&
                        'topRight' in digit &&
                        'mid' in digit &&
                        'bottomRight' in digit &&
                        'bottom' in digit
                    ) {
                        output = output.concat('3'); return
                    }
                    // digit 2
                    else if ('top' in digit &&
                        'topRight' in digit &&
                        'mid' in digit &&
                        'bottomLeft' in digit &&
                        'bottom' in digit
                    ) {
                        output = output.concat('2'); return
                    }
                    // digit 5
                    else output = output.concat('5'); return
                }
                case 6: {
                    let digit = {

                    }
                    for (let i = 0; i < x.length; i++) {
                        let char = x.charAt(i)
                        for (let key in signalPattern) {
                            if (char == signalPattern[key]) {
                                digit[key] = true;
                            }
                        }
                    }
                    //digit 0
                    if ('top' in digit &&
                        'topLeft' in digit &&
                        'topRight' in digit &&
                        'bottomLeft' in digit &&
                        'bottomRight' in digit &&
                        'bottom'
                    ) {
                        output = output.concat('0'); return;
                    }
                    // digit 6
                    else if ('top' in digit &&
                        'topLeft' in digit &&
                        'mid' in digit &&
                        'bottomLeft' in digit &&
                        'bottomRight' in digit &&
                        'bottom' in digit
                    ) {
                        output = output.concat('6'); return;
                    }
                    // digit 9
                    else output = output.concat('9'); return
                }
                case 7: output = output.concat('8'); return;
            }
        })
        return output;
    }
}
part2()
