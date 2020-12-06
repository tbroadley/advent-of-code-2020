import java.io.File

val input = File("6.txt").readLines()

val forms = mutableListOf(mutableListOf<String>())

for (line in input) {
  if (line.length == 0) {
    forms.add(mutableListOf())
    continue
  }

  forms.last().add(line)
}

val questionCounts = forms.map { form ->
  form.flatMap { it.toList() }.distinct().size
}
println(questionCounts.sum())

val questionCounts2 = forms.map { form ->
  ('a'..'z').filter { question -> form.all { it.contains(question) } }.size
}
println(questionCounts2.sum())
