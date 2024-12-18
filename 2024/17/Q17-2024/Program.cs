
using Q17_2024;


int getComboOperand(int A, int B, int C, int v)
{
    if (v>=0 && v<=3){
        return v;
    }
    if (v == 4){
        return A;
    }
    if (v == 5){
        return B;
    }
    if (v == 6){
        return C;
    }
    throw new Exception($"combo op : {v}");
}

int[] calc(int A,int[] program)
{
    var B = 0;
    var C = 0;
    var p = 0;
    bool running = true;
    var result = new List<int>();
    while (running) {

        var opcode = program[p++];

        if (opcode == 0) {
            var operand = program[p++];
            double d = getComboOperand(A,B,C,operand);
            d = Math.Pow(2,d);
            double div = (A / d);
            A = (int)Math.Floor(div);
        }

        if (opcode == 1) {
            var operand = program[p++];
            B = B ^ operand;
        }

        if (opcode == 2) {
            var operand = program[p++];
            var d = getComboOperand(A,B,C, operand);
            B = d % 8;
        }

        if (opcode == 3) {
            var operand = program[p++];
            if (A != 0)
            {
                p = operand;
            }
        }

        if (opcode == 4) {
            var operand = program[p++];
            B = B ^ C;
        }

        if (opcode == 5) {
            var operand = program[p++];
            var d = getComboOperand(A,B,C, operand);
            d = d % 8;
            result.Add(d);
        }

        if (opcode == 6) {
            var operand = program[p++];
            double d = getComboOperand(A,B,C, operand);
            d = Math.Pow(2, d);
            double div = (A / d);
            B = (int)Math.Floor(div);
        }

        if (opcode == 7) {
            var operand = program[p++];
            double d = getComboOperand(A,B,C, operand);
            d = Math.Pow(2, d);
            double div = (A / d);
            C = (int)Math.Floor(div);
        }

        if (p >= program.Length) {
            running = false;
        }

    }

    return result.ToArray();
}

//function comparePrograms($p1,$p2)
//{
//    if ($p1.count - ne $p2.count) {
//        return $false
//    }
//    for ($i = 0;$i - lt $p1.count;$i++){
//        if ($p1[$i] - ne $p2[$i]) {
//            return $false
//        }
//    }

//    return $true
//}

var registers = new Registers();

//registers.A = 37293246;
//registers.B = 0;
//registers.C = 0;
//int[] program = { 2, 4, 1, 6, 7, 5, 4, 4, 1, 7, 0, 3, 5, 5, 3, 0 };

registers.A = 2024;
registers.B = 0;
registers.C = 0;
int[] program = { 0, 3, 5, 4, 3, 0 };

bool equal = false;
while (!equal)
{
    registers.A++;
    if (registers.A % 1000 == 0) {
        Console.WriteLine($"A: {registers.A}");
    }
    var r = calc(registers.A, program);
    equal = r.SequenceEqual(program); 
}

Console.WriteLine($"result: {registers.A}");

// answer: 1,5,0,1,7,4,1,0,3