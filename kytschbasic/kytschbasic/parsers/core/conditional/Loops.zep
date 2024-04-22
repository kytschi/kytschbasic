/**
 * Loops parser
 *
 * @package     KytschBASIC\Parsers\Core\Conditional\Loops
 * @author 		Mike Welsh <hello@kytschi.com>
 * @copyright   2024 Mike Welsh
 * @link 		https://kytschbasic.org
 * @version     0.0.1
 *
 * Copyright 2024 Mike Welsh
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
namespace KytschBASIC\Parsers\Core\Conditional;

use KytschBASIC\Exceptions\Exception;
use KytschBASIC\Parsers\Core\Command;

class Loops extends Command
{
	public function parse(string command, args)
	{
		if (command == "WHILE") {
			return "<?php while(" . this->clean(args) . ") { ?>";
		} elseif (command == "WEND" || command == "FEND") {
			return "<?php } ?>";
		} elseif (command == "FOR") {
			return this->processFor(args);
		}

		return null;
	}

	private function processFor(args)
	{
		let args = explode(" IN ", args);
		if (count(args) < 1) {
			throw new Exception("Invalid for loop");
		}

		return "<?php foreach(" . this->clean(args[1]) . " as &" . this->clean(args[0]) . ") {?>";
	}
}