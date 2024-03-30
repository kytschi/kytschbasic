/**
 * Parser
 *
 * @package     KytschBASIC\Parsers\Core\Parser
 * @author 		Mike Welsh <hello@kytschi.com>
 * @copyright   2024 Mike Welsh
 * @link 		https://kytschbasic.org
 * @version     0.0.3
 *
 * Copyright 2023 Mike Welsh
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

use KytschBASIC\Exceptions\Exception;

class Parser
{
	private line_no = 0;
	private newline = "\n";

	/*
	 * Available parsers.
	 */
	private available = [
		"KytschBASIC\\Parsers\\Core\\Text\\Text",
		"KytschBASIC\\Parsers\\Core\\Layout\\Layout",
		"KytschBASIC\\Parsers\\Core\\Text\\Heading",
		"KytschBASIC\\Parsers\\Core\\Layout\\Head",
		"KytschBASIC\\Parsers\\Core\\Variables",
		"KytschBASIC\\Parsers\\Core\\Navigation",
		"KytschBASIC\\Parsers\\Core\\Load"
	];

	/*
	 * Build the template by parsing the commands.
	 */
	public function parse(string template)
	{
		var err, command = "", args = "", line = "", parser, parsers = [], commands, output = "", cprint = false;

		try {
			if (!file_exists(template)) {
				throw new Exception("Template, " . template . ", not found");
			}
			
			// Read the template lines.
			let commands = file(template);
			if (empty(commands)) {
				return;
			}

			for parser in this->available {
				let parsers[parser] = new {parser}();
			}

			for line in commands {
				let this->line_no += 1;

				if (line == "") {
					continue;
				}

				let parser = explode(" ", trim(line));
				let command = parser[0];
				array_shift(parser);
				if (isset(parser[0])) {
					if (parser[0] == "CLOSE") {
						let command .= " CLOSE";
						array_shift(parser);
					}
				}
				let args = implode(" ", parser);

				if (command == "CPRINT") {
					let cprint = true;
					let output .= "<pre><code>" . this->newline;
					continue;
				} elseif (command == "CPRINT CLOSE") {
					let cprint = false;
					let output .= "</code></pre>" . this->newline;
					continue;
				} elseif (command == "REM") {
					continue;
				}

				if (cprint) {
					let output .= line . this->newline;
					continue;
				}

				for parser in parsers {
					let line = parser->parse(command, args);
					if (!empty(line)) {
						let output .= line . this->newline;
						break;
					}
				}
			}

			return output;
		} catch Exception, err {
		    err->fatal(template, this->line_no);
		} catch \RuntimeException|\Exception, err {
			var newErr;
			let newErr = new Exception(err->getMessage(), err->getCode());

			echo newErr->fatal(template, this->line_no);
		}
    }
}
