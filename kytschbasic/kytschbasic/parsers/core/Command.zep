/**
 * Command parser
 *
 * @package     KytschBASIC\Parsers\Core\Command
 * @author 		Mike Welsh
 * @copyright   2022 Mike Welsh
 * @version     0.0.1
 *
 * Copyright 2022 Mike Welsh
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
 * Boston, MA  02110-1301, USA.
 */
namespace KytschBASIC\Parsers\Core;

class Command
{
	public static function cleanArg(
		string arg,
		bool slashes = true
	) {
		return slashes ? addslashes(trim(trim(arg), "\"")) : trim(trim(arg), "\"");
	}

	public static function genID(string id)
	{
		return id . "-" . hrtime(true);
	}

	public static function leftOverArgs(int start, args)
	{
		var bits, value, params = "";
		let args = array_slice(args, start, count(args) - start);

		for value in args {
			let bits = explode("$=", value);
			if (count(bits) == 1) {
				continue;
			}

			let params = params . " " . bits[0] . "=\"" . self::cleanArg(bits[1]) . "\"";
		}

		return params;
	}

	public static function match(line, command)
	{
		return (substr(line, 0, strlen(command)) == command) ? true : false;
	}

	public static function output(string code, bool withbr = false)
	{
		if (withbr) {
			let code = code . "<br/>";
		}

		return "echo '" . self::safe(code) . "';\n";
	}

	public static function parseArgs(
		string command,
		string line
	) {
		var key, value, splits = [], comma_code = base64_encode(microtime());

		let line = trim(substr_replace(line, "", 0, strlen(command)));

		if (line == "," || line == "\",\"" || empty(line)) {
			let splits[] = line;
			return splits;
		}

		let line = preg_replace_callback(
			"/(\"[^\",]+),([^\"]+\")/",
			function (matches) use (comma_code) {
				return str_replace(",", comma_code, matches[0]);
			},
			line
		);

		let splits = explode(",", line);

		if (strpos(line, comma_code) === false) {
			return splits;
		}

		for key, value in splits {
			let splits[key] = str_replace(comma_code, ",", value);
		}

		return splits;
	}

	public static function parseEquation(
		string line,
		string command = ""
	) {
		var vars, variable, find, has_string = false, codes = [], replaces = ["=", "==", "<=", ">=", ">", "<", "+"];

		for find in replaces {
			let codes[find] = base64_encode(microtime());
			let variable = codes[find];
			let line = preg_replace_callback(
				"/(\"[^\",]+)" . find . "([^\"]+\")/",
				function (matches) use (variable, find) {
					return str_replace(find, variable, matches[0]);
				},
				line
			);
		}

		if (command) {
			let line  = str_replace(command . " ", "", line);
		}

		let line = self::cleanArg(line, false);
		let line = str_replace(")", "]", str_replace(["$(", "%(", "#(", "("], "[", line));
		
		let vars = preg_split("/=|==|<=|>=|>|</", line);
						
		if (count(vars) > 1) {
			for variable in vars {
				var splits = preg_split("/\*|\+|\-|\//", variable, 0, 2);			
				for find in splits {
					let find = trim(find);
					if (!is_numeric(find)) {
						if (strpos(find, "\"") === false) {
							let line = str_replace(find, "$" . trim(trim(find), "$"), line);
						} else {							
							let has_string = true;
						}
					}
				}
			}

			if (has_string) {
				let line = str_replace("+", ".", line);
			}
			
			let line = self::replaceVars(line);
			
		} else {
			let vars = preg_split("/-/", line);

			if (count(vars) > 1) {
				for variable in vars {
					let variable = trim(variable);
					if (!is_numeric(variable)) {
						if (strpos(variable, "\"") === false) {
							let line = str_replace(variable, "$" . trim(trim(variable), "$"), line);
						}
					}
				}
			} else {
				let line = self::replaceVars(line);
			}
		}
		
		for find, variable in codes {
			let line = str_replace(variable, find, line);
		}

		let line = str_replace("$\"", "\"", line);
		return str_replace("$$", "$", line);
	}

	public static function parseSpaceArgs(
		string line,
		string command = ""
	) {
		if (command) {
			let line  = str_replace(command . " ", "", line);
		}
		return explode(" ", line);
	}

	private static function replaceVars(string line)
	{
		var vars, variable;

		preg_match_all("/\[(.*?)\]/", line, vars);
		if (count(vars) > 1) {
			for variable in vars[1] {
				if (!is_numeric(variable)) {
					let line = str_replace(variable, "$" . trim(trim(variable), "$"), line);
				}
			}
		}

		return str_replace("$$", "$", line);
	}

	public static function safe(string line)
	{
		return str_replace("'", "&#39;", line);
	}
}
