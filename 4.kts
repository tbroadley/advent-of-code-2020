import java.io.File

val input = File("4.txt").readLines()

val passports = mutableListOf<String>("")

for (line in input) {
  if (line.length == 0) {
    passports.add("")
    continue
  }

  passports[passports.size - 1] += "\n$line"
}

val validPassports = passports.filter { passport ->
  val colonCount = passport.count { it == ':' }
  colonCount == 8 || (colonCount == 7 && !passport.contains("cid:"))
}

println(validPassports.size)

enum class Field(
    val validator: (String) -> Boolean,
) {
  byr({ it.toInt() in 1920..2002 }),
  iyr({ it.toInt() in 2010..2020 }),
  eyr({ it.toInt() in 2020..2030 }),
  hgt({ value ->
    when (value.takeLast(2)) {
      "cm" -> value.dropLast(2).toInt() in 150..193
      "in" -> value.dropLast(2).toInt() in 59..76
      else -> false
    }
  }),
  hcl({ it.matches("#[0-9a-f]{6,6}".toRegex()) }),
  ecl({ it in listOf("amb", "blu", "brn", "gry", "grn", "hzl", "oth") }),
  pid({ it.matches("[0-9]{9,9}".toRegex()) }),
  cid({ true }),
}

val validPassports2 = passports.filter { passport ->
  val fields = "[a-z]{3,}:[^\\s]+".toRegex().findAll(passport)
      .map { it.value }
      .toList()

  return@filter enumValues<Field>().all { fieldEnum ->
    fieldEnum == Field.cid || fields.singleOrNull { field ->
      val (fieldName, fieldValue) = field.split(':')
      enumValueOf<Field>(fieldName) == fieldEnum && fieldEnum.validator(fieldValue)
    } != null
  }
}

println(validPassports2.size)
