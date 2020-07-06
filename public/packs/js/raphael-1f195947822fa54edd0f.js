/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/packs/";
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = "./app/javascript/packs/raphael.js");
/******/ })
/************************************************************************/
/******/ ({

/***/ "./app/javascript/packs/raphael.js":
/*!*****************************************!*\
  !*** ./app/javascript/packs/raphael.js ***!
  \*****************************************/
/*! no static exports found */
/***/ (function(module, exports) {

throw new Error("Module build failed (from ./node_modules/babel-loader/lib/index.js):\nSyntaxError: /Users/david/Winner-Stock/app/javascript/packs/raphael.js: Deleting local variable in strict mode (3718:59)\n\n  3716 |     \n  3717 |     R.ninja = function () {\n> 3718 |         oldRaphael.was ? (g.win.Raphael = oldRaphael.is) : delete Raphael;\n       |                                                            ^\n  3719 |         return R;\n  3720 |     };\n  3721 |     \n    at Parser._raise (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:746:17)\n    at Parser.raiseWithData (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:739:17)\n    at Parser.raise (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:733:17)\n    at Parser.parseMaybeUnary (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:9625:16)\n    at Parser.parseExprOps (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:9506:23)\n    at Parser.parseMaybeConditional (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:9479:23)\n    at Parser.parseMaybeAssign (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:9434:21)\n    at Parser.parseConditional (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:9495:29)\n    at Parser.parseMaybeConditional (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:9486:17)\n    at Parser.parseMaybeAssign (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:9434:21)\n    at Parser.parseExpression (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:9386:23)\n    at Parser.parseStatementContent (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:11285:23)\n    at Parser.parseStatement (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:11156:17)\n    at Parser.parseBlockOrModuleBlockBody (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:11731:25)\n    at Parser.parseBlockBody (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:11717:10)\n    at Parser.parseBlock (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:11701:10)\n    at Parser.parseFunctionBody (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:10708:24)\n    at Parser.parseFunctionBodyAndFinish (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:10691:10)\n    at withTopicForbiddingContext (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:11871:12)\n    at Parser.withTopicForbiddingContext (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:11031:14)\n    at Parser.parseFunction (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:11870:10)\n    at Parser.parseFunctionExpression (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:10171:17)\n    at Parser.parseExprAtom (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:10061:21)\n    at Parser.parseExprSubscripts (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:9656:23)\n    at Parser.parseMaybeUnary (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:9636:21)\n    at Parser.parseExprOps (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:9506:23)\n    at Parser.parseMaybeConditional (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:9479:23)\n    at Parser.parseMaybeAssign (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:9434:21)\n    at Parser.parseMaybeAssign (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:9466:25)\n    at Parser.parseExpression (/Users/david/Winner-Stock/node_modules/@babel/parser/lib/index.js:9386:23)");

/***/ })

/******/ });
//# sourceMappingURL=raphael-1f195947822fa54edd0f.js.map