/**
 * Compiler
 *
 * @package     KytschBASIC\Compiler
 * @author 		Mike Welsh
 * @copyright   2024 Mike Welsh <hello@kytschi.com>
 * @link 		https://kytschbasic.org
 * @version     0.0.2
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
namespace KytschBASIC;

use KytschBASIC\Exceptions\Exception;
use KytschBASIC\Parsers\Core\Parser;

class Compiler
{
	/**
	 * Var for holding the config object from the config JSON.
	 */
	private config;

	private globals = [];

	private start_time;
	private newline = "\n";

	private version = "0.0.11 alpha";

	public function __construct(string config_dir)
	{
		let this->start_time = microtime(true) * 1000;

		if (config_dir) {
			this->loadConfig(config_dir);
		}

		//Surpress the errors and let kytschBASIC take over.
		ini_set("display_errors", "0");
		register_shutdown_function(function() {
			var err;
			let err = error_get_last();
			if (err) {
				(new Exception(err["message"]))->fatal();
				die();
			}
		});

		define("VERSION", this->version);

		var url;
		let url = parse_url(_SERVER["REQUEST_URI"]);

		define("_ROOT", getcwd());

		/*let this->globals["_VALID"] = [];
		let this->globals["_VALID"]["captcha"] = this->validateCaptcha();
				
		let this->globals["_ROOT"] = getcwd();
		let this->globals["_RURL"] = _SERVER["REQUEST_SCHEME"] . "://" . _SERVER["HTTP_HOST"];
		let this->globals["_URL"] = _SERVER["REQUEST_URI"];
		let this->globals["_PATH"] = url["path"];
		let this->globals["_ARCADE"] = "kytschBASIC-arcade-internal-api";
		let this->globals["_AURL"] = this->globals["_RURL"] . "/" . this->globals["_ARCADE"];*/

		//define("VERSION", this->version);

		//Session::start(this->config);
	}

	/*
	 * Load the config file.
	 */
	public function loadConfig(string config_dir)
	{
		var err, config, filename;
		var configs = [
			"assets",
			"cache",
			"database",
			"routes",
			"security",
			"session"
		];

		let this->config = [];

		try {
			for config in configs {
				let filename = config_dir . "/" . config . ".json";
				if (!file_exists(filename)) {
					throw new Exception(
						"config not found, looking for " . config . ".json",
						400
					);
				}

				let this->config[config] = json_decode(file_get_contents(filename));
				if (empty(this->config)) {
					throw new Exception(
						"failed to decode the JSON",
						400
					);
				}
			}
		} catch Exception, err {
		    err->fatal();
		} catch \RuntimeException|\Exception, err {
		    throw new Exception(
				"Failed to load the config, " . err->getMessage(),
				err->getCode()
			);
		}
	}

	private function compile(route)
	{
		var err, output = "";

		var parsed = (new Parser())->parse(
			constant("_ROOT") . "/" . route->template,
			this->start_time
		);
		
		try {
			//let output = "<?php ";
			//let output = output . "$_VALID=unserialize('" . serialize(this->globals["_VALID"]) . "');?>";
			let output = output . "<!DOCTYPE html>" . this->newline;
			let output = output . parsed;
			file_put_contents(constant("_ROOT") . "/compiled.php", output);
			require (constant("_ROOT") . "/compiled.php");
		} catch \RuntimeException|\Exception, err {
			(new Exception(err->getMessage(), err->getCode()))->fatal();
		}
		return;
	}

	public function run()
	{
		if (empty(this->config["routes"])) {
			throw new \Exception("routes not defined in the config");
		}

		var url, fallback;
		let url = parse_url(_SERVER["REQUEST_URI"]);
		let fallback = null;

		if (isset(url["path"])) {
			var route;
			
			for route in this->config["routes"] {
				if (!isset(route->url)) {
					(new Exception("route URL not defined in the config"))->fatal();
				}
				if (!isset(route->template)) {
					(new Exception("route template not defined in the config"))->fatal();
				}

				//Fallback url, catch all basically.
				if (route->url == "*") {
					let fallback = route;
					continue;					
				}
				
				if (route->url == url["path"]) {
					return this->compile(route);
				}
			}
		}

		if (!empty(fallback)) {
			return this->compile(fallback);
		}

		(new Exception("Page not found", 404))->fatal();
	}
}
