/**
 * Table parser
 *
 * @package     KytschBASIC\Parsers\Core\Layout\Table
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
namespace KytschBASIC\Parsers\Core\Layout;

use KytschBASIC\Parsers\Core\Args;
use KytschBASIC\Parsers\Core\Command;

class Table extends Command
{
	public function parse(string command, string args)
	{
		if (command == "TABLE CLOSE") {
			return "</table>";
		} elseif (command == "TABLE") {
			return this->processTag("table", args);
		} elseif (command == "TBODY CLOSE") {
			return "</tbody>";
		} elseif (command == "TBODY") {
			return this->processTag("tbody", args);
		} elseif (command == "TCELL CLOSE") {
			return "</td>";
		} elseif (command == "TCELL") {
			return this->processCell("td", args);
		} elseif (command == "TFOOT CLOSE") {
			return "</tfoot>";
		} elseif (command == "TFOOT") {
			return this->processTag("tfoot", args);
		} elseif (command == "THEADCELL CLOSE") {
			return "</th>";
		} elseif (command == "THEADCELL") {
			return this->processCell("th", args);
		} elseif (command == "THEAD CLOSE") {
			return "</thead>";
		} elseif (command == "THEAD") {
			return this->processTag("thead", args);
		} elseif (command == "TROW CLOSE") {
			return "</tr>";
		} elseif (command == "TROW") {
			return this->processTag("tr", args);
		}

		return null;
	}

	private function processCell(string tag, string line)
	{
		var args, params="";

		let args = this->args(line);
		
		if (isset(args[0]) && !empty(args[0])) {
			let params .= " width='" . this->setArg(args[0]) . "'";
		}

		if (isset(args[1]) && !empty(args[1])) {
			let params .= " class='" . this->setArg(args[1]) . "'";
		}

		if (isset(args[2]) && !empty(args[2])) {
			let params .= " colspan='" . this->setArg(args[2]) . "'";
		}

		if (isset(args[3]) && !empty(args[3])) {
			let params .= " id='" . this->setArg(args[3]) . "'";
		} else {
			let params .= " id='" . this->genID("kb-" . tag) . "'";
		}
		
		return "<?= \"<" . tag . params . ">\"; ?>";
	}

	private function processTag(string tag, string line)
	{
		var args, params="";

		let args = this->args(line);
		
		if (isset(args[0]) && !empty(args[0])) {
			let params .= " class='" . this->setArg(args[0]) . "'";
		}

		if (isset(args[1]) && !empty(args[1])) {
			let params .= " id='" . this->setArg(args[1]) . "'";
		} else {
			let params .= " id='" . this->genID("kb-" . tag) . "'";
		}
		
		return "<?= \"<" . tag . params . ">\"; ?>";
	}
}
