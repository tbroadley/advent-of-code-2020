import _19.RuleDefinition.Expansion
import _19.RuleDefinition.Literal
import java.io.File

sealed class RuleDefinition {
  data class Literal(val string: String) : RuleDefinition()
  data class Expansion(val definitions: List<List<Int>>) : RuleDefinition()
}


fun parseRule(line: String): Pair<Int, RuleDefinition> {
  val (ruleNumberString, ruleDefinition) = line.split(": ")
  val ruleNumber = ruleNumberString.toInt()
  if (ruleDefinition.startsWith("\"")) return ruleNumber to Literal(ruleDefinition.substring(1, 2))

  val definitions = ruleDefinition.split(" | ")
      .map { lr -> lr.split(" ").map { it.toInt() } }
  return ruleNumber to Expansion(definitions)
}

val input = File("19.txt").readLines()
val emptyLineIndex = input.indexOf("")
val rules = input.take(emptyLineIndex).map { parseRule(it) }.toMap()
val messages = input.drop(emptyLineIndex + 1)

println(rules)
println(messages)
