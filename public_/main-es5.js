function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["main"], {
  /***/
  "./$$_lazy_route_resource lazy recursive":
  /*!******************************************************!*\
    !*** ./$$_lazy_route_resource lazy namespace object ***!
    \******************************************************/

  /*! no static exports found */

  /***/
  function $$_lazy_route_resourceLazyRecursive(module, exports) {
    function webpackEmptyAsyncContext(req) {
      // Here Promise.resolve().then() is used instead of new Promise() to prevent
      // uncaught exception popping up in devtools
      return Promise.resolve().then(function () {
        var e = new Error("Cannot find module '" + req + "'");
        e.code = 'MODULE_NOT_FOUND';
        throw e;
      });
    }

    webpackEmptyAsyncContext.keys = function () {
      return [];
    };

    webpackEmptyAsyncContext.resolve = webpackEmptyAsyncContext;
    module.exports = webpackEmptyAsyncContext;
    webpackEmptyAsyncContext.id = "./$$_lazy_route_resource lazy recursive";
    /***/
  },

  /***/
  "./node_modules/raw-loader/dist/cjs.js!./src/app/admin/add-unit-content/add-unit-content.component.html":
  /*!**************************************************************************************************************!*\
    !*** ./node_modules/raw-loader/dist/cjs.js!./src/app/admin/add-unit-content/add-unit-content.component.html ***!
    \**************************************************************************************************************/

  /*! exports provided: default */

  /***/
  function node_modulesRawLoaderDistCjsJsSrcAppAdminAddUnitContentAddUnitContentComponentHtml(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony default export */


    __webpack_exports__["default"] = "<form>\n\n    <div *ngFor=\"let word of unitWords\" class=\"form-group row\">\n        <div class=\"col-4\">\n            {{toString( word.from)}}\n        </div>\n        <div class=\"col-4\">\n            {{toString( word.to)}}\n        </div>\n        <div class=\"col-2\">\n            <input type=\"button\" (click)=\"remove(word)\" name=\"remove\" id=\"remove\" class=\"btn btn-secondary\"\n                value=\"Töröl\" />\n        </div>\n    </div>\n    <div class=\"form-group row\">\n        <div class=\"col-4\">\n            <div *ngFor=\"let phrase of fromPhrases; let in=index\">\n                <input type=\"text\" [(ngModel)]=\"fromPhrases[in].phrase\" name=\"from{{in}}\" autofocus id=\"from{{in}}\"\n                    class=\"form-control\" #name=\"ngModel\" required />\n            </div>\n        </div>\n        <div class=\"col-4\">\n            <div *ngFor=\"let phrase of toPhrases; let in=index\">\n                <input type=\"text\" [(ngModel)]=\"toPhrases[in].phrase\" name=\"to{{in}}\" autofocus id=\"to{{in}}\"\n                    class=\"form-control\" #name=\"ngModel\" required />\n            </div>\n        </div>\n    </div>\n    <div class=\"form-group row\">\n        <div class=\"col-4\">\n            <input type=\"button\" (click)=\"addFrom()\" name=\"addFrom\" id=\"addFrom\" class=\"btn btn-secondary\" value=\"+\" />\n            <input type=\"text\" [(ngModel)]=\"example\" name=\"example\" id=\"example\" class=\"form-control form-control-sm\" />\n        </div>\n        <div class=\"col-4\">\n            <input type=\"button\" (click)=\"addTo()\" name=\"addTo\" id=\"addTo\" class=\"btn btn-secondary\" value=\"+\" />\n            <input type=\"text\" [(ngModel)]=\"translatedExample\" name=\"translatedExample\" id=\"translatedExample\"\n                class=\"form-control form-control-sm\" />\n        </div>\n        <div class=\"col-2\">\n            <input type=\"submit\" (click)=\"add()\" name=\"add\" id=\"add\" class=\"btn btn-primary\" value=\"Hozzáad\" />\n        </div>\n    </div>\n</form>";
    /***/
  },

  /***/
  "./node_modules/raw-loader/dist/cjs.js!./src/app/admin/admin.html":
  /*!************************************************************************!*\
    !*** ./node_modules/raw-loader/dist/cjs.js!./src/app/admin/admin.html ***!
    \************************************************************************/

  /*! exports provided: default */

  /***/
  function node_modulesRawLoaderDistCjsJsSrcAppAdminAdminHtml(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony default export */


    __webpack_exports__["default"] = "<!--<div class=\"row\">\r\n        <div *ngFor=\"let group of groups\" style=\"margin-left: 5px\">\r\n          <div ngbDropdown class=\"d-inline-block\">\r\n            <button class=\"btn btn-outline-primary\" id=\"dropdownBasic1\" ngbDropdownToggle>{{group.name}}</button>\r\n            <div ngbDropdownMenu aria-labelledby=\"dropdownBasic1\">\r\n              <button *ngFor=\"let subGroup of group.group\" class=\"dropdown-item\" (click)=\"interrogate(subGroup.code)\">{{subGroup.name}}</button>\r\n            </div>\r\n          </div>\r\n        </div>\r\n</div>-->\r\nAdmin";
    /***/
  },

  /***/
  "./node_modules/raw-loader/dist/cjs.js!./src/app/app.component.html":
  /*!**************************************************************************!*\
    !*** ./node_modules/raw-loader/dist/cjs.js!./src/app/app.component.html ***!
    \**************************************************************************/

  /*! exports provided: default */

  /***/
  function node_modulesRawLoaderDistCjsJsSrcAppAppComponentHtml(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony default export */


    __webpack_exports__["default"] = "<group-selector></group-selector>\r\n<router-outlet></router-outlet>\r\n";
    /***/
  },

  /***/
  "./node_modules/raw-loader/dist/cjs.js!./src/app/core/login/login.component.html":
  /*!***************************************************************************************!*\
    !*** ./node_modules/raw-loader/dist/cjs.js!./src/app/core/login/login.component.html ***!
    \***************************************************************************************/

  /*! exports provided: default */

  /***/
  function node_modulesRawLoaderDistCjsJsSrcAppCoreLoginLoginComponentHtml(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony default export */


    __webpack_exports__["default"] = "<form class=\"form-signin\">\r\n  <h2>Login</h2>\r\n  <label for=\"username\" class=\"sr-only\">Username</label>\r\n  <input type=\"text\" required autofocus id=\"username\" #username placeholder=\"Username/Email\" />\r\n  <label for=\"password\" class=\"sr-only\">Password</label>\r\n  <input type=\"password\" class=\"form-control\" required autofocus id=\"password\" #password placeholder=\"Password\" />\r\n  <button type=\"button\" (click)=\"login(username.value, password.value)\">Login</button>\r\n</form>\r\n      ";
    /***/
  },

  /***/
  "./node_modules/raw-loader/dist/cjs.js!./src/app/core/not-found/not-found.component.html":
  /*!***********************************************************************************************!*\
    !*** ./node_modules/raw-loader/dist/cjs.js!./src/app/core/not-found/not-found.component.html ***!
    \***********************************************************************************************/

  /*! exports provided: default */

  /***/
  function node_modulesRawLoaderDistCjsJsSrcAppCoreNotFoundNotFoundComponentHtml(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony default export */


    __webpack_exports__["default"] = "<p>\r\n  not-found works!\r\n</p>\r\n";
    /***/
  },

  /***/
  "./node_modules/raw-loader/dist/cjs.js!./src/app/interrogator/group-selector.html":
  /*!****************************************************************************************!*\
    !*** ./node_modules/raw-loader/dist/cjs.js!./src/app/interrogator/group-selector.html ***!
    \****************************************************************************************/

  /*! exports provided: default */

  /***/
  function node_modulesRawLoaderDistCjsJsSrcAppInterrogatorGroupSelectorHtml(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony default export */


    __webpack_exports__["default"] = "<div class=\"row\">\r\n        <div *ngFor=\"let group of groups\" style=\"margin-left: 5px\">\r\n          <div ngbDropdown class=\"d-inline-block\">\r\n            <button class=\"btn btn-outline-primary\" id=\"dropdownBasic1\" ngbDropdownToggle>{{group.name}}</button>\r\n            <div ngbDropdownMenu aria-labelledby=\"dropdownBasic1\">\r\n              <button *ngFor=\"let subGroup of group.group\" class=\"dropdown-item\" (click)=\"interrogate(subGroup.code)\">{{subGroup.name}}</button>\r\n            </div>\r\n          </div>\r\n        </div>\r\n</div>";
    /***/
  },

  /***/
  "./node_modules/raw-loader/dist/cjs.js!./src/app/interrogator/interrogator.component.html":
  /*!************************************************************************************************!*\
    !*** ./node_modules/raw-loader/dist/cjs.js!./src/app/interrogator/interrogator.component.html ***!
    \************************************************************************************************/

  /*! exports provided: default */

  /***/
  function node_modulesRawLoaderDistCjsJsSrcAppInterrogatorInterrogatorComponentHtml(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony default export */


    __webpack_exports__["default"] = "<form>\r\n    <div *ngIf=\"word\">\r\n        <div>\r\n\r\n            <div style=\"display: flex\">\r\n                <div>{{word.from}}</div>\r\n                <div *ngIf=\"word.example\" style=\"margin-left: 5px\">[Példa mondat:\r\n                    {{word.example}}]</div>\r\n            </div>\r\n            <div class=\"form-group row\">\r\n                <div class=\"col-9\">\r\n                    <input type=\"text\" [(ngModel)]=\"to\" name=\"to\" autofocus [readonly]=\"checked\"\r\n                        autocomplete=\"off\" id=\"to\" class=\"form-control form-control-sm\" />\r\n                </div>\r\n                <div class=\"col-3\">\r\n                    <input type=\"submit\" (click)=\"check()\" value=\"Ellenőrzés\" *ngIf=\"!checked\" class=\"btn btn-primary\">\r\n                    <input type=\"submit\" (click)=\"next()\" value=\"Tovább\" *ngIf=\"checked\" class=\"btn btn-primary\">\r\n                </div>\r\n            </div>\r\n            <label *ngIf=\"checked && word.pronunciation\" class=\"col-form-label\" class=\"col-3\">\r\n                {{word.pronunciation}}\r\n            </label>\r\n            <ngb-alert [dismissible]=\"false\" *ngIf=\"checked && !wrong\" type=\"success\">Helyes! ({{word.to}})<div\r\n                    *ngIf=\"word.translatedExample\">[{{word.translatedExample}}]</div>\r\n            </ngb-alert>\r\n            <ngb-alert [dismissible]=\"false\" *ngIf=\"checked && wrong\" type=\"danger\">\r\n                <div>helyes válasz: {{word.to}}</div>\r\n                <div *ngIf=\"word.translatedExample\">[{{word.translatedExample}}]</div>\r\n            </ngb-alert>\r\n\r\n\r\n        </div>\r\n        <div>\r\n            <img *ngIf=\"word.imageUrl\" [src]=\"getImageUrl()\" />\r\n        </div>\r\n        <audio [src]=\"getAudio()\" *ngIf=\"word.audio\" id=\"audioplayer\"></audio>\r\n    </div>\r\n    <div *ngIf=\"actualWords && !word\">\r\n        Gratulálunk! Sikeresen befejezted.\r\n        <!--<input type=\"button\" (click)=\"back()\" value=\"Vissza\">-->\r\n    </div>\r\n</form>";
    /***/
  },

  /***/
  "./node_modules/raw-loader/dist/cjs.js!./src/app/interrogator/show-phrases/show-phrases.component.html":
  /*!*************************************************************************************************************!*\
    !*** ./node_modules/raw-loader/dist/cjs.js!./src/app/interrogator/show-phrases/show-phrases.component.html ***!
    \*************************************************************************************************************/

  /*! exports provided: default */

  /***/
  function node_modulesRawLoaderDistCjsJsSrcAppInterrogatorShowPhrasesShowPhrasesComponentHtml(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony default export */


    __webpack_exports__["default"] = "<div style=\"align-content: center; width: 100%;\">\n    <input type=\"button\" (click)=\"interrogateHere()\" value=\"Kikérdez\" class=\"btn btn-secondary\">\n    <input type=\"button\" (click)=\"interrogate()\" value=\"Kikérdez írásban\" class=\"btn btn-secondary\">\n    <input type=\"button\" (click)=\"addNew()\" value=\"Hozzáad\" class=\"btn btn-secondary\">\n    <table align=\"center\" class=\"table table-sm table-striped table-bordered table-hover\">\n        <tbody>\n            <tr *ngFor=\"let word of words; let i=index\" (click)=\"display(i)\">\n                <td style=\"width: 50%;\">{{word.from}}</td>\n                <td style=\"width: 50%;\"><span *ngIf=\"wordsDisplayed[i]\">{{word.to}}</span></td>\n            </tr>\n        </tbody>\n    </table>\n    <input type=\"button\" (click)=\"interrogateHere()\" value=\"Kikérdez\" class=\"btn btn-secondary\">\n    <input type=\"button\" (click)=\"interrogate()\" value=\"Kikérdez írásban\" class=\"btn btn-secondary\">\n    <input type=\"button\" (click)=\"addNew()\" value=\"Hozzáad\" class=\"btn btn-secondary\">\n</div>";
    /***/
  },

  /***/
  "./node_modules/tslib/tslib.es6.js":
  /*!*****************************************!*\
    !*** ./node_modules/tslib/tslib.es6.js ***!
    \*****************************************/

  /*! exports provided: __extends, __assign, __rest, __decorate, __param, __metadata, __awaiter, __generator, __exportStar, __values, __read, __spread, __spreadArrays, __await, __asyncGenerator, __asyncDelegator, __asyncValues, __makeTemplateObject, __importStar, __importDefault */

  /***/
  function node_modulesTslibTslibEs6Js(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "__extends", function () {
      return __extends;
    });
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "__assign", function () {
      return _assign;
    });
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "__rest", function () {
      return __rest;
    });
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "__decorate", function () {
      return __decorate;
    });
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "__param", function () {
      return __param;
    });
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "__metadata", function () {
      return __metadata;
    });
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "__awaiter", function () {
      return __awaiter;
    });
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "__generator", function () {
      return __generator;
    });
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "__exportStar", function () {
      return __exportStar;
    });
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "__values", function () {
      return __values;
    });
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "__read", function () {
      return __read;
    });
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "__spread", function () {
      return __spread;
    });
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "__spreadArrays", function () {
      return __spreadArrays;
    });
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "__await", function () {
      return __await;
    });
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "__asyncGenerator", function () {
      return __asyncGenerator;
    });
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "__asyncDelegator", function () {
      return __asyncDelegator;
    });
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "__asyncValues", function () {
      return __asyncValues;
    });
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "__makeTemplateObject", function () {
      return __makeTemplateObject;
    });
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "__importStar", function () {
      return __importStar;
    });
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "__importDefault", function () {
      return __importDefault;
    });
    /*! *****************************************************************************
    Copyright (c) Microsoft Corporation. All rights reserved.
    Licensed under the Apache License, Version 2.0 (the "License"); you may not use
    this file except in compliance with the License. You may obtain a copy of the
    License at http://www.apache.org/licenses/LICENSE-2.0
    
    THIS CODE IS PROVIDED ON AN *AS IS* BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION ANY IMPLIED
    WARRANTIES OR CONDITIONS OF TITLE, FITNESS FOR A PARTICULAR PURPOSE,
    MERCHANTABLITY OR NON-INFRINGEMENT.
    
    See the Apache Version 2.0 License for specific language governing permissions
    and limitations under the License.
    ***************************************************************************** */

    /* global Reflect, Promise */


    var _extendStatics = function extendStatics(d, b) {
      _extendStatics = Object.setPrototypeOf || {
        __proto__: []
      } instanceof Array && function (d, b) {
        d.__proto__ = b;
      } || function (d, b) {
        for (var p in b) {
          if (b.hasOwnProperty(p)) d[p] = b[p];
        }
      };

      return _extendStatics(d, b);
    };

    function __extends(d, b) {
      _extendStatics(d, b);

      function __() {
        this.constructor = d;
      }

      d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    }

    var _assign = function __assign() {
      _assign = Object.assign || function __assign(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
          s = arguments[i];

          for (var p in s) {
            if (Object.prototype.hasOwnProperty.call(s, p)) t[p] = s[p];
          }
        }

        return t;
      };

      return _assign.apply(this, arguments);
    };

    function __rest(s, e) {
      var t = {};

      for (var p in s) {
        if (Object.prototype.hasOwnProperty.call(s, p) && e.indexOf(p) < 0) t[p] = s[p];
      }

      if (s != null && typeof Object.getOwnPropertySymbols === "function") for (var i = 0, p = Object.getOwnPropertySymbols(s); i < p.length; i++) {
        if (e.indexOf(p[i]) < 0 && Object.prototype.propertyIsEnumerable.call(s, p[i])) t[p[i]] = s[p[i]];
      }
      return t;
    }

    function __decorate(decorators, target, key, desc) {
      var c = arguments.length,
          r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc,
          d;
      if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);else for (var i = decorators.length - 1; i >= 0; i--) {
        if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
      }
      return c > 3 && r && Object.defineProperty(target, key, r), r;
    }

    function __param(paramIndex, decorator) {
      return function (target, key) {
        decorator(target, key, paramIndex);
      };
    }

    function __metadata(metadataKey, metadataValue) {
      if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(metadataKey, metadataValue);
    }

    function __awaiter(thisArg, _arguments, P, generator) {
      return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) {
          try {
            step(generator.next(value));
          } catch (e) {
            reject(e);
          }
        }

        function rejected(value) {
          try {
            step(generator["throw"](value));
          } catch (e) {
            reject(e);
          }
        }

        function step(result) {
          result.done ? resolve(result.value) : new P(function (resolve) {
            resolve(result.value);
          }).then(fulfilled, rejected);
        }

        step((generator = generator.apply(thisArg, _arguments || [])).next());
      });
    }

    function __generator(thisArg, body) {
      var _ = {
        label: 0,
        sent: function sent() {
          if (t[0] & 1) throw t[1];
          return t[1];
        },
        trys: [],
        ops: []
      },
          f,
          y,
          t,
          g;
      return g = {
        next: verb(0),
        "throw": verb(1),
        "return": verb(2)
      }, typeof Symbol === "function" && (g[Symbol.iterator] = function () {
        return this;
      }), g;

      function verb(n) {
        return function (v) {
          return step([n, v]);
        };
      }

      function step(op) {
        if (f) throw new TypeError("Generator is already executing.");

        while (_) {
          try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];

            switch (op[0]) {
              case 0:
              case 1:
                t = op;
                break;

              case 4:
                _.label++;
                return {
                  value: op[1],
                  done: false
                };

              case 5:
                _.label++;
                y = op[1];
                op = [0];
                continue;

              case 7:
                op = _.ops.pop();

                _.trys.pop();

                continue;

              default:
                if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) {
                  _ = 0;
                  continue;
                }

                if (op[0] === 3 && (!t || op[1] > t[0] && op[1] < t[3])) {
                  _.label = op[1];
                  break;
                }

                if (op[0] === 6 && _.label < t[1]) {
                  _.label = t[1];
                  t = op;
                  break;
                }

                if (t && _.label < t[2]) {
                  _.label = t[2];

                  _.ops.push(op);

                  break;
                }

                if (t[2]) _.ops.pop();

                _.trys.pop();

                continue;
            }

            op = body.call(thisArg, _);
          } catch (e) {
            op = [6, e];
            y = 0;
          } finally {
            f = t = 0;
          }
        }

        if (op[0] & 5) throw op[1];
        return {
          value: op[0] ? op[1] : void 0,
          done: true
        };
      }
    }

    function __exportStar(m, exports) {
      for (var p in m) {
        if (!exports.hasOwnProperty(p)) exports[p] = m[p];
      }
    }

    function __values(o) {
      var m = typeof Symbol === "function" && o[Symbol.iterator],
          i = 0;
      if (m) return m.call(o);
      return {
        next: function next() {
          if (o && i >= o.length) o = void 0;
          return {
            value: o && o[i++],
            done: !o
          };
        }
      };
    }

    function __read(o, n) {
      var m = typeof Symbol === "function" && o[Symbol.iterator];
      if (!m) return o;
      var i = m.call(o),
          r,
          ar = [],
          e;

      try {
        while ((n === void 0 || n-- > 0) && !(r = i.next()).done) {
          ar.push(r.value);
        }
      } catch (error) {
        e = {
          error: error
        };
      } finally {
        try {
          if (r && !r.done && (m = i["return"])) m.call(i);
        } finally {
          if (e) throw e.error;
        }
      }

      return ar;
    }

    function __spread() {
      for (var ar = [], i = 0; i < arguments.length; i++) {
        ar = ar.concat(__read(arguments[i]));
      }

      return ar;
    }

    function __spreadArrays() {
      for (var s = 0, i = 0, il = arguments.length; i < il; i++) {
        s += arguments[i].length;
      }

      for (var r = Array(s), k = 0, i = 0; i < il; i++) {
        for (var a = arguments[i], j = 0, jl = a.length; j < jl; j++, k++) {
          r[k] = a[j];
        }
      }

      return r;
    }

    ;

    function __await(v) {
      return this instanceof __await ? (this.v = v, this) : new __await(v);
    }

    function __asyncGenerator(thisArg, _arguments, generator) {
      if (!Symbol.asyncIterator) throw new TypeError("Symbol.asyncIterator is not defined.");
      var g = generator.apply(thisArg, _arguments || []),
          i,
          q = [];
      return i = {}, verb("next"), verb("throw"), verb("return"), i[Symbol.asyncIterator] = function () {
        return this;
      }, i;

      function verb(n) {
        if (g[n]) i[n] = function (v) {
          return new Promise(function (a, b) {
            q.push([n, v, a, b]) > 1 || resume(n, v);
          });
        };
      }

      function resume(n, v) {
        try {
          step(g[n](v));
        } catch (e) {
          settle(q[0][3], e);
        }
      }

      function step(r) {
        r.value instanceof __await ? Promise.resolve(r.value.v).then(fulfill, reject) : settle(q[0][2], r);
      }

      function fulfill(value) {
        resume("next", value);
      }

      function reject(value) {
        resume("throw", value);
      }

      function settle(f, v) {
        if (f(v), q.shift(), q.length) resume(q[0][0], q[0][1]);
      }
    }

    function __asyncDelegator(o) {
      var i, p;
      return i = {}, verb("next"), verb("throw", function (e) {
        throw e;
      }), verb("return"), i[Symbol.iterator] = function () {
        return this;
      }, i;

      function verb(n, f) {
        i[n] = o[n] ? function (v) {
          return (p = !p) ? {
            value: __await(o[n](v)),
            done: n === "return"
          } : f ? f(v) : v;
        } : f;
      }
    }

    function __asyncValues(o) {
      if (!Symbol.asyncIterator) throw new TypeError("Symbol.asyncIterator is not defined.");
      var m = o[Symbol.asyncIterator],
          i;
      return m ? m.call(o) : (o = typeof __values === "function" ? __values(o) : o[Symbol.iterator](), i = {}, verb("next"), verb("throw"), verb("return"), i[Symbol.asyncIterator] = function () {
        return this;
      }, i);

      function verb(n) {
        i[n] = o[n] && function (v) {
          return new Promise(function (resolve, reject) {
            v = o[n](v), settle(resolve, reject, v.done, v.value);
          });
        };
      }

      function settle(resolve, reject, d, v) {
        Promise.resolve(v).then(function (v) {
          resolve({
            value: v,
            done: d
          });
        }, reject);
      }
    }

    function __makeTemplateObject(cooked, raw) {
      if (Object.defineProperty) {
        Object.defineProperty(cooked, "raw", {
          value: raw
        });
      } else {
        cooked.raw = raw;
      }

      return cooked;
    }

    ;

    function __importStar(mod) {
      if (mod && mod.__esModule) return mod;
      var result = {};
      if (mod != null) for (var k in mod) {
        if (Object.hasOwnProperty.call(mod, k)) result[k] = mod[k];
      }
      result.default = mod;
      return result;
    }

    function __importDefault(mod) {
      return mod && mod.__esModule ? mod : {
        default: mod
      };
    }
    /***/

  },

  /***/
  "./src/app/admin/add-unit-content/add-unit-content.component.css":
  /*!***********************************************************************!*\
    !*** ./src/app/admin/add-unit-content/add-unit-content.component.css ***!
    \***********************************************************************/

  /*! exports provided: default */

  /***/
  function srcAppAdminAddUnitContentAddUnitContentComponentCss(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony default export */


    __webpack_exports__["default"] = "\n/*# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IiIsImZpbGUiOiJzcmMvYXBwL2FkbWluL2FkZC11bml0LWNvbnRlbnQvYWRkLXVuaXQtY29udGVudC5jb21wb25lbnQuY3NzIn0= */";
    /***/
  },

  /***/
  "./src/app/admin/add-unit-content/add-unit-content.component.ts":
  /*!**********************************************************************!*\
    !*** ./src/app/admin/add-unit-content/add-unit-content.component.ts ***!
    \**********************************************************************/

  /*! exports provided: AddUnitContentComponent */

  /***/
  function srcAppAdminAddUnitContentAddUnitContentComponentTs(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "AddUnitContentComponent", function () {
      return AddUnitContentComponent;
    });
    /* harmony import */


    var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
    /*! tslib */
    "./node_modules/tslib/tslib.es6.js");
    /* harmony import */


    var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(
    /*! @angular/core */
    "./node_modules/@angular/core/fesm2015/core.js");
    /* harmony import */


    var src_app_models_word__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(
    /*! src/app/models/word */
    "./src/app/models/word.ts");
    /* harmony import */


    var src_app_services_word_service__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(
    /*! src/app/services/word-service */
    "./src/app/services/word-service.ts");
    /* harmony import */


    var _angular_router__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(
    /*! @angular/router */
    "./node_modules/@angular/router/fesm2015/router.js");
    /* harmony import */


    var rxjs_operators__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(
    /*! rxjs/operators */
    "./node_modules/rxjs/_esm2015/operators/index.js");
    /* harmony import */


    var src_app_models_phrase__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(
    /*! src/app/models/phrase */
    "./src/app/models/phrase.ts");
    /* harmony import */


    var src_app_models_translation_to_save__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(
    /*! src/app/models/translation-to-save */
    "./src/app/models/translation-to-save.ts");

    var AddUnitContentComponent =
    /*#__PURE__*/
    function () {
      function AddUnitContentComponent(wordService, route, router) {
        _classCallCheck(this, AddUnitContentComponent);

        this.wordService = wordService;
        this.route = route;
        this.router = router;
        this.fromPhrases = [new src_app_models_phrase__WEBPACK_IMPORTED_MODULE_6__["Phrase"]('')];
        this.toPhrases = [new src_app_models_phrase__WEBPACK_IMPORTED_MODULE_6__["Phrase"]('')];
      }

      _createClass(AddUnitContentComponent, [{
        key: "ngOnInit",
        value: function ngOnInit() {
          var _this = this;

          this.unitWords = this.wordService.getActualWords();

          if (!this.unitWords) {
            this.route.paramMap.pipe(Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_5__["switchMap"])(function (params) {
              _this.unitId = params.get('id');
              return _this.wordService.getWords(_this.unitId);
            })).subscribe(function (words) {
              if (words != null) {
                _this.unitWords = words;
              } else {
                _this.unitWords = new Array(0);
              }
            });
          } else {
            this.route.paramMap.pipe(Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_5__["switchMap"])(function (params) {
              return _this.unitId = params.get('id');
            }));
          }
        }
      }, {
        key: "toString",
        value: function toString(phraseArray) {
          var result = "";
          var _iteratorNormalCompletion = true;
          var _didIteratorError = false;
          var _iteratorError = undefined;

          try {
            for (var _iterator = phraseArray[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
              var phrase = _step.value;
              result = result + ";" + phrase.phrase;
            }
          } catch (err) {
            _didIteratorError = true;
            _iteratorError = err;
          } finally {
            try {
              if (!_iteratorNormalCompletion && _iterator.return != null) {
                _iterator.return();
              }
            } finally {
              if (_didIteratorError) {
                throw _iteratorError;
              }
            }
          }

          result = result.substr(1);
          return result;
        }
      }, {
        key: "addFrom",
        value: function addFrom() {
          this.fromPhrases.push(new src_app_models_phrase__WEBPACK_IMPORTED_MODULE_6__["Phrase"](''));
        }
      }, {
        key: "addTo",
        value: function addTo() {
          this.toPhrases.push(new src_app_models_phrase__WEBPACK_IMPORTED_MODULE_6__["Phrase"](''));
        }
      }, {
        key: "add",
        value: function add() {
          var _this2 = this;

          if (!this.isPhrasesFilled(this.fromPhrases) || !this.isPhrasesFilled(this.toPhrases)) {
            return;
          }

          var translation = new src_app_models_translation_to_save__WEBPACK_IMPORTED_MODULE_7__["TranslationToSave"](this.unitId, this.getPhraseStrings(this.fromPhrases), this.getPhraseStrings(this.toPhrases), this.example, this.translatedExample);
          this.wordService.addUnitContent(translation).then(function (unitContentId) {
            if (unitContentId) {
              var word = new src_app_models_word__WEBPACK_IMPORTED_MODULE_2__["Word"](unitContentId, _this2.fromPhrases, _this2.toPhrases, _this2.example, _this2.translatedExample);

              _this2.unitWords.push(word); // clear the inputs


              _this2.fromPhrases = [new src_app_models_phrase__WEBPACK_IMPORTED_MODULE_6__["Phrase"]('')];
              _this2.toPhrases = [new src_app_models_phrase__WEBPACK_IMPORTED_MODULE_6__["Phrase"]('')];
              _this2.example = '';
              _this2.translatedExample = '';
            }
          });
        }
      }, {
        key: "remove",
        value: function remove(wordToRemove) {
          var _this3 = this;

          this.wordService.removeUnitContent(parseInt(wordToRemove.id)).then(function (res) {
            if (res) {
              var index = _this3.unitWords.indexOf(wordToRemove, 0);

              if (index > -1) {
                _this3.unitWords.splice(index, 1);
              }
            }
          });
          return;
        }
      }, {
        key: "getPhraseStrings",
        value: function getPhraseStrings(phrases) {
          var strings = new Array();
          phrases.forEach(function (phrase) {
            strings.push(phrase.phrase);
          });
          return strings;
        }
      }, {
        key: "isPhrasesFilled",
        value: function isPhrasesFilled(phrases) {
          var result = true;
          phrases.forEach(function (phrase) {
            if (phrase === undefined || phrase == null) {
              result = false;
              return;
            } else if (phrase.phrase == undefined || phrase.phrase == null || phrase.phrase.trim() == '') {
              result = false;
              return;
            }
          });
          return result;
        }
      }]);

      return AddUnitContentComponent;
    }();

    AddUnitContentComponent.ctorParameters = function () {
      return [{
        type: src_app_services_word_service__WEBPACK_IMPORTED_MODULE_3__["WordService"]
      }, {
        type: _angular_router__WEBPACK_IMPORTED_MODULE_4__["ActivatedRoute"]
      }, {
        type: _angular_router__WEBPACK_IMPORTED_MODULE_4__["Router"]
      }];
    };

    AddUnitContentComponent = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Component"])({
      selector: 'app-add-unit-content',
      template: tslib__WEBPACK_IMPORTED_MODULE_0__["__importDefault"](__webpack_require__(
      /*! raw-loader!./add-unit-content.component.html */
      "./node_modules/raw-loader/dist/cjs.js!./src/app/admin/add-unit-content/add-unit-content.component.html")).default,
      styles: [tslib__WEBPACK_IMPORTED_MODULE_0__["__importDefault"](__webpack_require__(
      /*! ./add-unit-content.component.css */
      "./src/app/admin/add-unit-content/add-unit-content.component.css")).default]
    })], AddUnitContentComponent);
    /***/
  },

  /***/
  "./src/app/admin/admin.component.ts":
  /*!******************************************!*\
    !*** ./src/app/admin/admin.component.ts ***!
    \******************************************/

  /*! exports provided: AdminComponent */

  /***/
  function srcAppAdminAdminComponentTs(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "AdminComponent", function () {
      return AdminComponent;
    });
    /* harmony import */


    var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
    /*! tslib */
    "./node_modules/tslib/tslib.es6.js");
    /* harmony import */


    var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(
    /*! @angular/core */
    "./node_modules/@angular/core/fesm2015/core.js");
    /* harmony import */


    var _angular_router__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(
    /*! @angular/router */
    "./node_modules/@angular/router/fesm2015/router.js");
    /* harmony import */


    var _services_word_service__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(
    /*! ../services/word-service */
    "./src/app/services/word-service.ts");

    var AdminComponent =
    /*#__PURE__*/
    function () {
      function AdminComponent(wordService, route, router) {
        _classCallCheck(this, AdminComponent);

        this.wordService = wordService;
        this.route = route;
        this.router = router;
      }

      _createClass(AdminComponent, [{
        key: "ngOnInit",
        value: function ngOnInit() {
          var _this4 = this;

          this.wordService.getGroups().then(function (groups) {
            return _this4.groups = groups;
          });
        }
      }, {
        key: "interrogate",
        value: function interrogate(key) {
          this.router.navigate(['/interrogator', key, 'db']);
        }
      }]);

      return AdminComponent;
    }();

    AdminComponent.ctorParameters = function () {
      return [{
        type: _services_word_service__WEBPACK_IMPORTED_MODULE_3__["WordService"]
      }, {
        type: _angular_router__WEBPACK_IMPORTED_MODULE_2__["ActivatedRoute"]
      }, {
        type: _angular_router__WEBPACK_IMPORTED_MODULE_2__["Router"]
      }];
    };

    AdminComponent = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Component"])({
      selector: 'admin',
      template: tslib__WEBPACK_IMPORTED_MODULE_0__["__importDefault"](__webpack_require__(
      /*! raw-loader!./admin.html */
      "./node_modules/raw-loader/dist/cjs.js!./src/app/admin/admin.html")).default
    })], AdminComponent);
    /***/
  },

  /***/
  "./src/app/admin/admin.module.ts":
  /*!***************************************!*\
    !*** ./src/app/admin/admin.module.ts ***!
    \***************************************/

  /*! exports provided: AdminModule */

  /***/
  function srcAppAdminAdminModuleTs(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "AdminModule", function () {
      return AdminModule;
    });
    /* harmony import */


    var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
    /*! tslib */
    "./node_modules/tslib/tslib.es6.js");
    /* harmony import */


    var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(
    /*! @angular/core */
    "./node_modules/@angular/core/fesm2015/core.js");
    /* harmony import */


    var _angular_forms__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(
    /*! @angular/forms */
    "./node_modules/@angular/forms/fesm2015/forms.js");
    /* harmony import */


    var _angular_http__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(
    /*! @angular/http */
    "./node_modules/@angular/http/fesm2015/http.js");
    /* harmony import */


    var _angular_common__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(
    /*! @angular/common */
    "./node_modules/@angular/common/fesm2015/common.js");
    /* harmony import */


    var _ng_bootstrap_ng_bootstrap__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(
    /*! @ng-bootstrap/ng-bootstrap */
    "./node_modules/@ng-bootstrap/ng-bootstrap/fesm2015/ng-bootstrap.js");
    /* harmony import */


    var _admin_component__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(
    /*! ./admin.component */
    "./src/app/admin/admin.component.ts");

    var AdminModule = function AdminModule() {
      _classCallCheck(this, AdminModule);
    };

    AdminModule = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["NgModule"])({
      imports: [_angular_common__WEBPACK_IMPORTED_MODULE_4__["CommonModule"], _angular_forms__WEBPACK_IMPORTED_MODULE_2__["FormsModule"], _angular_http__WEBPACK_IMPORTED_MODULE_3__["HttpModule"], _ng_bootstrap_ng_bootstrap__WEBPACK_IMPORTED_MODULE_5__["NgbModule"]],
      declarations: [_admin_component__WEBPACK_IMPORTED_MODULE_6__["AdminComponent"]],
      exports: [_admin_component__WEBPACK_IMPORTED_MODULE_6__["AdminComponent"], _ng_bootstrap_ng_bootstrap__WEBPACK_IMPORTED_MODULE_5__["NgbModule"]],
      entryComponents: []
    })], AdminModule);
    /***/
  },

  /***/
  "./src/app/app.component.css":
  /*!***********************************!*\
    !*** ./src/app/app.component.css ***!
    \***********************************/

  /*! exports provided: default */

  /***/
  function srcAppAppComponentCss(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony default export */


    __webpack_exports__["default"] = "main {\r\n  padding: 1em;\r\n  font-family: Arial, Helvetica, sans-serif;\r\n  text-align: center;\r\n  margin-top: 50px;\r\n  display: block;\r\n}\r\n\r\n/*# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbInNyYy9hcHAvYXBwLmNvbXBvbmVudC5jc3MiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IkFBQUE7RUFDRSxZQUFZO0VBQ1oseUNBQXlDO0VBQ3pDLGtCQUFrQjtFQUNsQixnQkFBZ0I7RUFDaEIsY0FBYztBQUNoQiIsImZpbGUiOiJzcmMvYXBwL2FwcC5jb21wb25lbnQuY3NzIiwic291cmNlc0NvbnRlbnQiOlsibWFpbiB7XHJcbiAgcGFkZGluZzogMWVtO1xyXG4gIGZvbnQtZmFtaWx5OiBBcmlhbCwgSGVsdmV0aWNhLCBzYW5zLXNlcmlmO1xyXG4gIHRleHQtYWxpZ246IGNlbnRlcjtcclxuICBtYXJnaW4tdG9wOiA1MHB4O1xyXG4gIGRpc3BsYXk6IGJsb2NrO1xyXG59XHJcbiJdfQ== */";
    /***/
  },

  /***/
  "./src/app/app.component.ts":
  /*!**********************************!*\
    !*** ./src/app/app.component.ts ***!
    \**********************************/

  /*! exports provided: AppComponent */

  /***/
  function srcAppAppComponentTs(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "AppComponent", function () {
      return AppComponent;
    });
    /* harmony import */


    var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
    /*! tslib */
    "./node_modules/tslib/tslib.es6.js");
    /* harmony import */


    var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(
    /*! @angular/core */
    "./node_modules/@angular/core/fesm2015/core.js");
    /* harmony import */


    var _assets_css_styles_css__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(
    /*! ../assets/css/styles.css */
    "./src/assets/css/styles.css");

    var AppComponent = function AppComponent() {
      _classCallCheck(this, AppComponent);
    };

    AppComponent = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Component"])({
      selector: 'learn-english-app',
      template: tslib__WEBPACK_IMPORTED_MODULE_0__["__importDefault"](__webpack_require__(
      /*! raw-loader!./app.component.html */
      "./node_modules/raw-loader/dist/cjs.js!./src/app/app.component.html")).default,
      styles: [tslib__WEBPACK_IMPORTED_MODULE_0__["__importDefault"](__webpack_require__(
      /*! ./app.component.css */
      "./src/app/app.component.css")).default]
    })], AppComponent);
    /***/
  },

  /***/
  "./src/app/app.module.ts":
  /*!*******************************!*\
    !*** ./src/app/app.module.ts ***!
    \*******************************/

  /*! exports provided: AppModule */

  /***/
  function srcAppAppModuleTs(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "AppModule", function () {
      return AppModule;
    });
    /* harmony import */


    var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
    /*! tslib */
    "./node_modules/tslib/tslib.es6.js");
    /* harmony import */


    var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(
    /*! @angular/core */
    "./node_modules/@angular/core/fesm2015/core.js");
    /* harmony import */


    var _angular_forms__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(
    /*! @angular/forms */
    "./node_modules/@angular/forms/fesm2015/forms.js");
    /* harmony import */


    var _angular_http__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(
    /*! @angular/http */
    "./node_modules/@angular/http/fesm2015/http.js");
    /* harmony import */


    var _angular_platform_browser__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(
    /*! @angular/platform-browser */
    "./node_modules/@angular/platform-browser/fesm2015/platform-browser.js");
    /* harmony import */


    var _angular_platform_browser_animations__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(
    /*! @angular/platform-browser/animations */
    "./node_modules/@angular/platform-browser/fesm2015/animations.js");
    /* harmony import */


    var _app_component__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(
    /*! ./app.component */
    "./src/app/app.component.ts");
    /* harmony import */


    var _services_word_service__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(
    /*! ./services/word-service */
    "./src/app/services/word-service.ts");
    /* harmony import */


    var _interrogator_interrogator_module__WEBPACK_IMPORTED_MODULE_8__ = __webpack_require__(
    /*! ./interrogator/interrogator.module */
    "./src/app/interrogator/interrogator.module.ts");
    /* harmony import */


    var _admin_admin_module__WEBPACK_IMPORTED_MODULE_9__ = __webpack_require__(
    /*! ./admin/admin.module */
    "./src/app/admin/admin.module.ts");
    /* harmony import */


    var _core_core_module__WEBPACK_IMPORTED_MODULE_10__ = __webpack_require__(
    /*! ./core/core.module */
    "./src/app/core/core.module.ts");
    /* harmony import */


    var _interrogator_show_phrases_show_phrases_component__WEBPACK_IMPORTED_MODULE_11__ = __webpack_require__(
    /*! ./interrogator/show-phrases/show-phrases.component */
    "./src/app/interrogator/show-phrases/show-phrases.component.ts");
    /* harmony import */


    var _admin_add_unit_content_add_unit_content_component__WEBPACK_IMPORTED_MODULE_12__ = __webpack_require__(
    /*! ./admin/add-unit-content/add-unit-content.component */
    "./src/app/admin/add-unit-content/add-unit-content.component.ts");

    var AppModule = function AppModule() {
      _classCallCheck(this, AppModule);
    };

    AppModule = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["NgModule"])({
      imports: [_angular_platform_browser__WEBPACK_IMPORTED_MODULE_4__["BrowserModule"], _angular_platform_browser_animations__WEBPACK_IMPORTED_MODULE_5__["BrowserAnimationsModule"], _angular_forms__WEBPACK_IMPORTED_MODULE_2__["FormsModule"], _angular_http__WEBPACK_IMPORTED_MODULE_3__["HttpModule"], _interrogator_interrogator_module__WEBPACK_IMPORTED_MODULE_8__["InterrogatorModule"], _admin_admin_module__WEBPACK_IMPORTED_MODULE_9__["AdminModule"], _core_core_module__WEBPACK_IMPORTED_MODULE_10__["CoreModule"]],
      declarations: [_app_component__WEBPACK_IMPORTED_MODULE_6__["AppComponent"], _interrogator_show_phrases_show_phrases_component__WEBPACK_IMPORTED_MODULE_11__["ShowPhrasesComponent"], _admin_add_unit_content_add_unit_content_component__WEBPACK_IMPORTED_MODULE_12__["AddUnitContentComponent"]],
      bootstrap: [_app_component__WEBPACK_IMPORTED_MODULE_6__["AppComponent"]],
      providers: [_services_word_service__WEBPACK_IMPORTED_MODULE_7__["WordService"]]
    })], AppModule);
    /***/
  },

  /***/
  "./src/app/auth-services/auth-guard.service.ts":
  /*!*****************************************************!*\
    !*** ./src/app/auth-services/auth-guard.service.ts ***!
    \*****************************************************/

  /*! exports provided: AuthGuardService */

  /***/
  function srcAppAuthServicesAuthGuardServiceTs(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "AuthGuardService", function () {
      return AuthGuardService;
    });
    /* harmony import */


    var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
    /*! tslib */
    "./node_modules/tslib/tslib.es6.js");
    /* harmony import */


    var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(
    /*! @angular/core */
    "./node_modules/@angular/core/fesm2015/core.js");
    /* harmony import */


    var _authentication_service__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(
    /*! ./authentication.service */
    "./src/app/auth-services/authentication.service.ts");
    /* harmony import */


    var _angular_router__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(
    /*! @angular/router */
    "./node_modules/@angular/router/fesm2015/router.js");

    var AuthGuardService =
    /*#__PURE__*/
    function () {
      function AuthGuardService(authentication, router) {
        _classCallCheck(this, AuthGuardService);

        this.authentication = authentication;
        this.router = router;
      }

      _createClass(AuthGuardService, [{
        key: "canActivate",
        value: function canActivate() {
          var token = this.authentication.getToken();
          var accessToken = this.authentication.getAccessToken();

          if (!token) {
            console.error("User is not authenticated.");
            this.redirectToLoginPage();
            return false;
          } else if (this.authentication.isAuthenticated()) {
            return true;
          } else {
            this.authentication.refreshToken();
            return true;
          }
        }
      }, {
        key: "redirectToLoginPage",
        value: function redirectToLoginPage() {
          this.router.navigate(['/login']);
        }
      }]);

      return AuthGuardService;
    }();

    AuthGuardService.ctorParameters = function () {
      return [{
        type: _authentication_service__WEBPACK_IMPORTED_MODULE_2__["AuthenticationService"]
      }, {
        type: _angular_router__WEBPACK_IMPORTED_MODULE_3__["Router"]
      }];
    };

    AuthGuardService = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Injectable"])()], AuthGuardService);
    /***/
  },

  /***/
  "./src/app/auth-services/authentication.service.ts":
  /*!*********************************************************!*\
    !*** ./src/app/auth-services/authentication.service.ts ***!
    \*********************************************************/

  /*! exports provided: AuthenticationService */

  /***/
  function srcAppAuthServicesAuthenticationServiceTs(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "AuthenticationService", function () {
      return AuthenticationService;
    });
    /* harmony import */


    var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
    /*! tslib */
    "./node_modules/tslib/tslib.es6.js");
    /* harmony import */


    var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(
    /*! @angular/core */
    "./node_modules/@angular/core/fesm2015/core.js");
    /* harmony import */


    var _angular_router__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(
    /*! @angular/router */
    "./node_modules/@angular/router/fesm2015/router.js");

    var AuthenticationService =
    /*#__PURE__*/
    function () {
      function AuthenticationService(router) {
        _classCallCheck(this, AuthenticationService);

        this.router = router;
        this.token = {
          refresh_token: 'refreshtokencode',
          exp: new Date(new Date().getDate() + 1),
          access_token: {
            username: 'user',
            roles: ['Admin', 'RegisteredUser', 'Super User']
          }
        };
        this.tokenKey = "a5smm_utoken";
      }

      _createClass(AuthenticationService, [{
        key: "login",
        value: function login(username, password) {
          this.setToken(this.token);
          this.router.navigate(['admin', 'dashboard']);
        }
      }, {
        key: "logout",
        value: function logout() {
          this.removeToken();
          this.router.navigate(['login']);
        }
      }, {
        key: "getToken",
        value: function getToken() {
          return JSON.parse(localStorage.getItem(this.tokenKey));
        }
      }, {
        key: "setToken",
        value: function setToken(token) {
          localStorage.setItem(this.tokenKey, JSON.stringify(token));
        }
      }, {
        key: "getAccessToken",
        value: function getAccessToken() {
          return JSON.parse(localStorage.getItem(this.tokenKey))['access_token'];
        }
      }, {
        key: "isAuthenticated",
        value: function isAuthenticated() {
          var token = localStorage.getItem(this.tokenKey);

          if (token) {
            return true;
          } else {
            return false;
          }
        }
      }, {
        key: "refreshToken",
        value: function refreshToken() {
          this.token.exp = new Date(new Date().getDate() + 1);
          this.setToken(this.token);
        }
      }, {
        key: "removeToken",
        value: function removeToken() {
          localStorage.removeItem(this.tokenKey);
        }
      }]);

      return AuthenticationService;
    }();

    AuthenticationService.ctorParameters = function () {
      return [{
        type: _angular_router__WEBPACK_IMPORTED_MODULE_2__["Router"]
      }];
    };

    AuthenticationService = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Injectable"])()], AuthenticationService);
    /***/
  },

  /***/
  "./src/app/core/core-routing.module.ts":
  /*!*********************************************!*\
    !*** ./src/app/core/core-routing.module.ts ***!
    \*********************************************/

  /*! exports provided: CoreRoutingModule */

  /***/
  function srcAppCoreCoreRoutingModuleTs(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "CoreRoutingModule", function () {
      return CoreRoutingModule;
    });
    /* harmony import */


    var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
    /*! tslib */
    "./node_modules/tslib/tslib.es6.js");
    /* harmony import */


    var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(
    /*! @angular/core */
    "./node_modules/@angular/core/fesm2015/core.js");
    /* harmony import */


    var _angular_router__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(
    /*! @angular/router */
    "./node_modules/@angular/router/fesm2015/router.js");
    /* harmony import */


    var _not_found_not_found_component__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(
    /*! ./not-found/not-found.component */
    "./src/app/core/not-found/not-found.component.ts");
    /* harmony import */


    var _login_login_component__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(
    /*! ./login/login.component */
    "./src/app/core/login/login.component.ts");
    /* harmony import */


    var _interrogator_interrogator_component__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(
    /*! ../interrogator/interrogator.component */
    "./src/app/interrogator/interrogator.component.ts");
    /* harmony import */


    var _interrogator_show_phrases_show_phrases_component__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(
    /*! ../interrogator/show-phrases/show-phrases.component */
    "./src/app/interrogator/show-phrases/show-phrases.component.ts");
    /* harmony import */


    var _admin_add_unit_content_add_unit_content_component__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(
    /*! ../admin/add-unit-content/add-unit-content.component */
    "./src/app/admin/add-unit-content/add-unit-content.component.ts");

    var routes = [{
      path: '',
      redirectTo: 'interrogator',
      pathMatch: 'full'
    }, {
      path: 'login',
      component: _login_login_component__WEBPACK_IMPORTED_MODULE_4__["LoginComponent"]
    },
    /*{
      path: 'admin',
      canActivate: [AuthGuardService],
      loadChildren: '../admin/admin.module#AdminModule'
    },*/
    {
      path: 'admin/addUnitContent/:id',
      component: _admin_add_unit_content_add_unit_content_component__WEBPACK_IMPORTED_MODULE_7__["AddUnitContentComponent"]
    }, {
      path: 'interrogator/show/:id',
      component: _interrogator_show_phrases_show_phrases_component__WEBPACK_IMPORTED_MODULE_6__["ShowPhrasesComponent"]
    }, {
      path: 'interrogator/:id',
      component: _interrogator_interrogator_component__WEBPACK_IMPORTED_MODULE_5__["InterrogatorComponent"]
    }, {
      path: 'interrogator',
      component: _interrogator_interrogator_component__WEBPACK_IMPORTED_MODULE_5__["InterrogatorComponent"]
    }, {
      path: '**',
      component: _not_found_not_found_component__WEBPACK_IMPORTED_MODULE_3__["NotFoundComponent"]
    }];

    var CoreRoutingModule = function CoreRoutingModule() {
      _classCallCheck(this, CoreRoutingModule);
    };

    CoreRoutingModule = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["NgModule"])({
      imports: [_angular_router__WEBPACK_IMPORTED_MODULE_2__["RouterModule"].forRoot(routes)],
      exports: [_angular_router__WEBPACK_IMPORTED_MODULE_2__["RouterModule"]]
    })], CoreRoutingModule);
    /***/
  },

  /***/
  "./src/app/core/core.module.ts":
  /*!*************************************!*\
    !*** ./src/app/core/core.module.ts ***!
    \*************************************/

  /*! exports provided: CoreModule */

  /***/
  function srcAppCoreCoreModuleTs(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "CoreModule", function () {
      return CoreModule;
    });
    /* harmony import */


    var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
    /*! tslib */
    "./node_modules/tslib/tslib.es6.js");
    /* harmony import */


    var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(
    /*! @angular/core */
    "./node_modules/@angular/core/fesm2015/core.js");
    /* harmony import */


    var _angular_common__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(
    /*! @angular/common */
    "./node_modules/@angular/common/fesm2015/common.js");
    /* harmony import */


    var _core_routing_module__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(
    /*! ./core-routing.module */
    "./src/app/core/core-routing.module.ts");
    /* harmony import */


    var _login_login_component__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(
    /*! ./login/login.component */
    "./src/app/core/login/login.component.ts");
    /* harmony import */


    var _not_found_not_found_component__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(
    /*! ./not-found/not-found.component */
    "./src/app/core/not-found/not-found.component.ts");
    /* harmony import */


    var _angular_router__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(
    /*! @angular/router */
    "./node_modules/@angular/router/fesm2015/router.js");
    /* harmony import */


    var _auth_services_authentication_service__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(
    /*! ../auth-services/authentication.service */
    "./src/app/auth-services/authentication.service.ts");
    /* harmony import */


    var _auth_services_auth_guard_service__WEBPACK_IMPORTED_MODULE_8__ = __webpack_require__(
    /*! ../auth-services/auth-guard.service */
    "./src/app/auth-services/auth-guard.service.ts");
    /* harmony import */


    var _interrogator_interrogator_module__WEBPACK_IMPORTED_MODULE_9__ = __webpack_require__(
    /*! ../interrogator/interrogator.module */
    "./src/app/interrogator/interrogator.module.ts");

    var CoreModule = function CoreModule() {
      _classCallCheck(this, CoreModule);
    };

    CoreModule = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["NgModule"])({
      imports: [_angular_common__WEBPACK_IMPORTED_MODULE_2__["CommonModule"], _core_routing_module__WEBPACK_IMPORTED_MODULE_3__["CoreRoutingModule"], _interrogator_interrogator_module__WEBPACK_IMPORTED_MODULE_9__["InterrogatorModule"]],
      declarations: [_login_login_component__WEBPACK_IMPORTED_MODULE_4__["LoginComponent"], _not_found_not_found_component__WEBPACK_IMPORTED_MODULE_5__["NotFoundComponent"]],
      exports: [_angular_router__WEBPACK_IMPORTED_MODULE_6__["RouterModule"]],
      providers: [_auth_services_authentication_service__WEBPACK_IMPORTED_MODULE_7__["AuthenticationService"], _auth_services_auth_guard_service__WEBPACK_IMPORTED_MODULE_8__["AuthGuardService"]]
    })], CoreModule);
    /***/
  },

  /***/
  "./src/app/core/login/login.component.ts":
  /*!***********************************************!*\
    !*** ./src/app/core/login/login.component.ts ***!
    \***********************************************/

  /*! exports provided: LoginComponent */

  /***/
  function srcAppCoreLoginLoginComponentTs(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "LoginComponent", function () {
      return LoginComponent;
    });
    /* harmony import */


    var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
    /*! tslib */
    "./node_modules/tslib/tslib.es6.js");
    /* harmony import */


    var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(
    /*! @angular/core */
    "./node_modules/@angular/core/fesm2015/core.js");
    /* harmony import */


    var _auth_services_authentication_service__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(
    /*! ../../auth-services/authentication.service */
    "./src/app/auth-services/authentication.service.ts");
    /* harmony import */


    var _angular_router__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(
    /*! @angular/router */
    "./node_modules/@angular/router/fesm2015/router.js");

    var LoginComponent =
    /*#__PURE__*/
    function () {
      function LoginComponent(authentication, router) {
        _classCallCheck(this, LoginComponent);

        this.authentication = authentication;
        this.router = router;
      }

      _createClass(LoginComponent, [{
        key: "ngOnInit",
        value: function ngOnInit() {}
      }, {
        key: "login",
        value: function login(username, password) {
          this.authentication.login(username, password);
        }
      }]);

      return LoginComponent;
    }();

    LoginComponent.ctorParameters = function () {
      return [{
        type: _auth_services_authentication_service__WEBPACK_IMPORTED_MODULE_2__["AuthenticationService"]
      }, {
        type: _angular_router__WEBPACK_IMPORTED_MODULE_3__["Router"]
      }];
    };

    LoginComponent = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Component"])({
      selector: 'app-login',
      template: tslib__WEBPACK_IMPORTED_MODULE_0__["__importDefault"](__webpack_require__(
      /*! raw-loader!./login.component.html */
      "./node_modules/raw-loader/dist/cjs.js!./src/app/core/login/login.component.html")).default
    })], LoginComponent);
    /***/
  },

  /***/
  "./src/app/core/not-found/not-found.component.ts":
  /*!*******************************************************!*\
    !*** ./src/app/core/not-found/not-found.component.ts ***!
    \*******************************************************/

  /*! exports provided: NotFoundComponent */

  /***/
  function srcAppCoreNotFoundNotFoundComponentTs(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "NotFoundComponent", function () {
      return NotFoundComponent;
    });
    /* harmony import */


    var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
    /*! tslib */
    "./node_modules/tslib/tslib.es6.js");
    /* harmony import */


    var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(
    /*! @angular/core */
    "./node_modules/@angular/core/fesm2015/core.js");

    var NotFoundComponent =
    /*#__PURE__*/
    function () {
      function NotFoundComponent() {
        _classCallCheck(this, NotFoundComponent);
      }

      _createClass(NotFoundComponent, [{
        key: "ngOnInit",
        value: function ngOnInit() {}
      }]);

      return NotFoundComponent;
    }();

    NotFoundComponent = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Component"])({
      selector: 'app-not-found',
      template: tslib__WEBPACK_IMPORTED_MODULE_0__["__importDefault"](__webpack_require__(
      /*! raw-loader!./not-found.component.html */
      "./node_modules/raw-loader/dist/cjs.js!./src/app/core/not-found/not-found.component.html")).default
    })], NotFoundComponent);
    /***/
  },

  /***/
  "./src/app/interrogator/group-selector.component.ts":
  /*!**********************************************************!*\
    !*** ./src/app/interrogator/group-selector.component.ts ***!
    \**********************************************************/

  /*! exports provided: GroupSelectorComponent */

  /***/
  function srcAppInterrogatorGroupSelectorComponentTs(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "GroupSelectorComponent", function () {
      return GroupSelectorComponent;
    });
    /* harmony import */


    var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
    /*! tslib */
    "./node_modules/tslib/tslib.es6.js");
    /* harmony import */


    var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(
    /*! @angular/core */
    "./node_modules/@angular/core/fesm2015/core.js");
    /* harmony import */


    var _angular_router__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(
    /*! @angular/router */
    "./node_modules/@angular/router/fesm2015/router.js");
    /* harmony import */


    var _services_word_service__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(
    /*! ../services/word-service */
    "./src/app/services/word-service.ts");

    var GroupSelectorComponent =
    /*#__PURE__*/
    function () {
      function GroupSelectorComponent(wordService, route, router) {
        _classCallCheck(this, GroupSelectorComponent);

        this.wordService = wordService;
        this.route = route;
        this.router = router;
      }

      _createClass(GroupSelectorComponent, [{
        key: "ngOnInit",
        value: function ngOnInit() {
          var _this5 = this;

          this.wordService.getGroups().then(function (groups) {
            return _this5.groups = groups;
          });
        }
      }, {
        key: "interrogate",
        value: function interrogate(key) {
          this.router.navigate(['/interrogator/show', key]);
        }
      }]);

      return GroupSelectorComponent;
    }();

    GroupSelectorComponent.ctorParameters = function () {
      return [{
        type: _services_word_service__WEBPACK_IMPORTED_MODULE_3__["WordService"]
      }, {
        type: _angular_router__WEBPACK_IMPORTED_MODULE_2__["ActivatedRoute"]
      }, {
        type: _angular_router__WEBPACK_IMPORTED_MODULE_2__["Router"]
      }];
    };

    GroupSelectorComponent = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Component"])({
      selector: 'group-selector',
      template: tslib__WEBPACK_IMPORTED_MODULE_0__["__importDefault"](__webpack_require__(
      /*! raw-loader!./group-selector.html */
      "./node_modules/raw-loader/dist/cjs.js!./src/app/interrogator/group-selector.html")).default
    })], GroupSelectorComponent);
    /***/
  },

  /***/
  "./src/app/interrogator/guessed-word-converter.ts":
  /*!********************************************************!*\
    !*** ./src/app/interrogator/guessed-word-converter.ts ***!
    \********************************************************/

  /*! exports provided: GuessedWordConverter */

  /***/
  function srcAppInterrogatorGuessedWordConverterTs(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "GuessedWordConverter", function () {
      return GuessedWordConverter;
    });
    /* harmony import */


    var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
    /*! tslib */
    "./node_modules/tslib/tslib.es6.js");
    /* harmony import */


    var _models_guessed_word__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(
    /*! ../models/guessed-word */
    "./src/app/models/guessed-word.ts");

    var GuessedWordConverter =
    /*#__PURE__*/
    function () {
      function GuessedWordConverter() {
        _classCallCheck(this, GuessedWordConverter);
      }

      _createClass(GuessedWordConverter, [{
        key: "convertToGuessed",
        value: function convertToGuessed(words) {
          if (words == null) {
            return null;
          }

          var actualWords = new Array(words.length);
          var i = 0;
          var _iteratorNormalCompletion2 = true;
          var _didIteratorError2 = false;
          var _iteratorError2 = undefined;

          try {
            for (var _iterator2 = words[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
              var word = _step2.value;
              actualWords[i] = this.clone(word);
              i++;
            }
          } catch (err) {
            _didIteratorError2 = true;
            _iteratorError2 = err;
          } finally {
            try {
              if (!_iteratorNormalCompletion2 && _iterator2.return != null) {
                _iterator2.return();
              }
            } finally {
              if (_didIteratorError2) {
                throw _iteratorError2;
              }
            }
          }

          return actualWords;
        }
      }, {
        key: "clone",
        value: function clone(source) {
          var cloned = new _models_guessed_word__WEBPACK_IMPORTED_MODULE_1__["GuessedWord"](); // tslint:disable-next-line:forin

          for (var prop in source) {
            cloned[prop] = source[prop];
          } // convert the from and to arrays to string


          cloned.from = "";
          var _iteratorNormalCompletion3 = true;
          var _didIteratorError3 = false;
          var _iteratorError3 = undefined;

          try {
            for (var _iterator3 = source.from[Symbol.iterator](), _step3; !(_iteratorNormalCompletion3 = (_step3 = _iterator3.next()).done); _iteratorNormalCompletion3 = true) {
              var phrase = _step3.value;
              cloned.from = cloned.from + ";" + phrase.phrase;
            }
          } catch (err) {
            _didIteratorError3 = true;
            _iteratorError3 = err;
          } finally {
            try {
              if (!_iteratorNormalCompletion3 && _iterator3.return != null) {
                _iterator3.return();
              }
            } finally {
              if (_didIteratorError3) {
                throw _iteratorError3;
              }
            }
          }

          cloned.from = cloned.from.substr(1);
          cloned.to = new Array(source.to.length);
          var i = 0;
          var _iteratorNormalCompletion4 = true;
          var _didIteratorError4 = false;
          var _iteratorError4 = undefined;

          try {
            for (var _iterator4 = source.to[Symbol.iterator](), _step4; !(_iteratorNormalCompletion4 = (_step4 = _iterator4.next()).done); _iteratorNormalCompletion4 = true) {
              var _phrase = _step4.value;
              cloned.to[i] = _phrase.phrase;
              i++;
            }
          } catch (err) {
            _didIteratorError4 = true;
            _iteratorError4 = err;
          } finally {
            try {
              if (!_iteratorNormalCompletion4 && _iterator4.return != null) {
                _iterator4.return();
              }
            } finally {
              if (_didIteratorError4) {
                throw _iteratorError4;
              }
            }
          }

          return cloned;
        }
      }]);

      return GuessedWordConverter;
    }();
    /***/

  },

  /***/
  "./src/app/interrogator/interrogator.component.css":
  /*!*********************************************************!*\
    !*** ./src/app/interrogator/interrogator.component.css ***!
    \*********************************************************/

  /*! exports provided: default */

  /***/
  function srcAppInterrogatorInterrogatorComponentCss(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony default export */


    __webpack_exports__["default"] = "main {\r\n  padding: 1em;\r\n  font-family: Arial, Helvetica, sans-serif;\r\n  text-align: center;\r\n  margin-top: 50px;\r\n  display: block;\r\n}\r\n\r\n/*# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbInNyYy9hcHAvaW50ZXJyb2dhdG9yL2ludGVycm9nYXRvci5jb21wb25lbnQuY3NzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiJBQUFBO0VBQ0UsWUFBWTtFQUNaLHlDQUF5QztFQUN6QyxrQkFBa0I7RUFDbEIsZ0JBQWdCO0VBQ2hCLGNBQWM7QUFDaEIiLCJmaWxlIjoic3JjL2FwcC9pbnRlcnJvZ2F0b3IvaW50ZXJyb2dhdG9yLmNvbXBvbmVudC5jc3MiLCJzb3VyY2VzQ29udGVudCI6WyJtYWluIHtcclxuICBwYWRkaW5nOiAxZW07XHJcbiAgZm9udC1mYW1pbHk6IEFyaWFsLCBIZWx2ZXRpY2EsIHNhbnMtc2VyaWY7XHJcbiAgdGV4dC1hbGlnbjogY2VudGVyO1xyXG4gIG1hcmdpbi10b3A6IDUwcHg7XHJcbiAgZGlzcGxheTogYmxvY2s7XHJcbn1cclxuIl19 */";
    /***/
  },

  /***/
  "./src/app/interrogator/interrogator.component.ts":
  /*!********************************************************!*\
    !*** ./src/app/interrogator/interrogator.component.ts ***!
    \********************************************************/

  /*! exports provided: InterrogatorComponent */

  /***/
  function srcAppInterrogatorInterrogatorComponentTs(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "InterrogatorComponent", function () {
      return InterrogatorComponent;
    });
    /* harmony import */


    var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
    /*! tslib */
    "./node_modules/tslib/tslib.es6.js");
    /* harmony import */


    var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(
    /*! @angular/core */
    "./node_modules/@angular/core/fesm2015/core.js");
    /* harmony import */


    var _angular_router__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(
    /*! @angular/router */
    "./node_modules/@angular/router/fesm2015/router.js");
    /* harmony import */


    var _services_word_service__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(
    /*! ../services/word-service */
    "./src/app/services/word-service.ts");
    /* harmony import */


    var rxjs_operators__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(
    /*! rxjs/operators */
    "./node_modules/rxjs/_esm2015/operators/index.js");
    /* harmony import */


    var _guessed_word_converter__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(
    /*! ./guessed-word-converter */
    "./src/app/interrogator/guessed-word-converter.ts");

    var InterrogatorComponent =
    /*#__PURE__*/
    function () {
      function InterrogatorComponent(wordService, route, router) {
        _classCallCheck(this, InterrogatorComponent);

        this.wordService = wordService;
        this.route = route;
        this.router = router;
        this.actualWords = null;
        this.word = null;
        this.checked = false;
        this.wrong = false;
      }

      _createClass(InterrogatorComponent, [{
        key: "ngOnInit",
        value: function ngOnInit() {
          var _this6 = this;

          this.actualWords = new _guessed_word_converter__WEBPACK_IMPORTED_MODULE_5__["GuessedWordConverter"]().convertToGuessed(this.wordService.getActualWords());

          if (this.actualWords) {
            this.next();
          } else {
            this.route.paramMap.pipe(Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_4__["switchMap"])(function (params) {
              var unitId = params.get('id');

              if (unitId) {
                return _this6.wordService.getWords(params.get('id'));
              } else {
                return new Promise(function (resolve) {
                  resolve();
                });
              }
            })).subscribe(function (words) {
              if (words) {
                _this6.actualWords = new _guessed_word_converter__WEBPACK_IMPORTED_MODULE_5__["GuessedWordConverter"]().convertToGuessed(words);

                _this6.next();
              }
            });
          }
        }
      }, {
        key: "check",
        value: function check() {
          if (this.isEqual(this.word.to, this.to)) {
            // if this is the last or the last answer was not wrong, then remove from the array
            if (!this.word.lastAnswerWrong || this.actualWords.length === 1) {
              this.actualWords.splice(this.index, 1);
            }

            this.word.incrementCorrectAnswer();
          } else {
            this.word.incrementWrongAnswer();
            this.wrong = true;
          }

          this.checked = true; // play the audio if available

          if (this.word.audio) {
            var player = document.getElementById('audioplayer');
            player.play();
          }
        }
      }, {
        key: "isEqual",
        value: function isEqual(expectedArray, actual) {
          if (actual === null) {
            return false;
          }

          var _iteratorNormalCompletion5 = true;
          var _didIteratorError5 = false;
          var _iteratorError5 = undefined;

          try {
            for (var _iterator5 = expectedArray[Symbol.iterator](), _step5; !(_iteratorNormalCompletion5 = (_step5 = _iterator5.next()).done); _iteratorNormalCompletion5 = true) {
              var expected = _step5.value;

              if (expected === actual) {
                return true;
              }

              var expectedModified = expected.toUpperCase();
              var actualModified = actual.toUpperCase();

              if (expectedModified === actualModified) {
                return true;
              }

              expectedModified = this.replaceAbbreviation(expectedModified);
              actualModified = this.replaceAbbreviation(actualModified);

              if (expectedModified === actualModified) {
                return true;
              }

              expectedModified = this.removeUnnecessaryCharacters(expectedModified);
              actualModified = this.removeUnnecessaryCharacters(actualModified);

              if (expectedModified === actualModified) {
                return true;
              }
            }
          } catch (err) {
            _didIteratorError5 = true;
            _iteratorError5 = err;
          } finally {
            try {
              if (!_iteratorNormalCompletion5 && _iterator5.return != null) {
                _iterator5.return();
              }
            } finally {
              if (_didIteratorError5) {
                throw _iteratorError5;
              }
            }
          }

          return false;
        }
      }, {
        key: "replaceAbbreviation",
        value: function replaceAbbreviation(source) {
          var result = this.replace(source, 'WHAT\'S', 'WHAT IS');
          result = this.replace(source, 'I\'M', 'I AM'); // result = this.replace(source, 'I\'M', 'I AM');

          return result;
        }
      }, {
        key: "replace",
        value: function replace(source, search, _replace) {
          return source.replace(new RegExp(search, 'g'), _replace);
        }
      }, {
        key: "removeUnnecessaryCharacters",
        value: function removeUnnecessaryCharacters(text) {
          var result = '';
          var _iteratorNormalCompletion6 = true;
          var _didIteratorError6 = false;
          var _iteratorError6 = undefined;

          try {
            for (var _iterator6 = text[Symbol.iterator](), _step6; !(_iteratorNormalCompletion6 = (_step6 = _iterator6.next()).done); _iteratorNormalCompletion6 = true) {
              var char = _step6.value;

              switch (char) {
                case '?':
                case '.':
                case '!':
                case ':':
                case ',':
                case ';':
                case ' ':
                  break;

                default:
                  result = result + char;
              }
            }
          } catch (err) {
            _didIteratorError6 = true;
            _iteratorError6 = err;
          } finally {
            try {
              if (!_iteratorNormalCompletion6 && _iterator6.return != null) {
                _iterator6.return();
              }
            } finally {
              if (_didIteratorError6) {
                throw _iteratorError6;
              }
            }
          }

          return result;
        }
      }, {
        key: "next",
        value: function next() {
          this.word = this.getRandomWord(this.word && this.word.lastAnswerWrong);
          this.checked = false;
          this.wrong = false;
          this.to = null;

          if (this.word != null && document.getElementById('to') != null) {
            document.getElementById('to').focus();
          }
        }
        /**
         * @param checkSameIndex true, if must not get the same word as it was answered now
         */

      }, {
        key: "getRandomWord",
        value: function getRandomWord(checkSameIndex) {
          var remainingWordsNumber = this.actualWords != null ? this.actualWords.length : 0; // if no more words, then return null

          if (remainingWordsNumber === 0) {
            return null;
          } else {
            var tempIndex = this.getRandomIndex(remainingWordsNumber); // if this is the last, then no need to get new random number

            if (checkSameIndex && remainingWordsNumber > 1) {
              while (this.index === tempIndex) {
                tempIndex = this.getRandomIndex(remainingWordsNumber);
              }
            }

            this.index = tempIndex;
            return this.actualWords[this.index];
          }
        }
      }, {
        key: "getRandomIndex",
        value: function getRandomIndex(length) {
          return Math.floor(Math.random() * length);
        }
      }, {
        key: "getImageUrl",
        value: function getImageUrl() {
          return; //require('../../assets/images/' + this.word.imageUrl);
        }
      }, {
        key: "getAudio",
        value: function getAudio() {
          return; //require('../../assets/audios/' + this.word.audio);
        }
      }, {
        key: "back",
        value: function back() {
          this.router.navigate(['']);
        }
      }]);

      return InterrogatorComponent;
    }();

    InterrogatorComponent.ctorParameters = function () {
      return [{
        type: _services_word_service__WEBPACK_IMPORTED_MODULE_3__["WordService"]
      }, {
        type: _angular_router__WEBPACK_IMPORTED_MODULE_2__["ActivatedRoute"]
      }, {
        type: _angular_router__WEBPACK_IMPORTED_MODULE_2__["Router"]
      }];
    };

    InterrogatorComponent = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Component"])({
      selector: 'interrogator',
      template: tslib__WEBPACK_IMPORTED_MODULE_0__["__importDefault"](__webpack_require__(
      /*! raw-loader!./interrogator.component.html */
      "./node_modules/raw-loader/dist/cjs.js!./src/app/interrogator/interrogator.component.html")).default,
      styles: [tslib__WEBPACK_IMPORTED_MODULE_0__["__importDefault"](__webpack_require__(
      /*! ./interrogator.component.css */
      "./src/app/interrogator/interrogator.component.css")).default]
    })], InterrogatorComponent);
    /***/
  },

  /***/
  "./src/app/interrogator/interrogator.module.ts":
  /*!*****************************************************!*\
    !*** ./src/app/interrogator/interrogator.module.ts ***!
    \*****************************************************/

  /*! exports provided: InterrogatorModule */

  /***/
  function srcAppInterrogatorInterrogatorModuleTs(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "InterrogatorModule", function () {
      return InterrogatorModule;
    });
    /* harmony import */


    var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
    /*! tslib */
    "./node_modules/tslib/tslib.es6.js");
    /* harmony import */


    var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(
    /*! @angular/core */
    "./node_modules/@angular/core/fesm2015/core.js");
    /* harmony import */


    var _angular_forms__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(
    /*! @angular/forms */
    "./node_modules/@angular/forms/fesm2015/forms.js");
    /* harmony import */


    var _angular_http__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(
    /*! @angular/http */
    "./node_modules/@angular/http/fesm2015/http.js");
    /* harmony import */


    var _angular_common__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(
    /*! @angular/common */
    "./node_modules/@angular/common/fesm2015/common.js");
    /* harmony import */


    var _ng_bootstrap_ng_bootstrap__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(
    /*! @ng-bootstrap/ng-bootstrap */
    "./node_modules/@ng-bootstrap/ng-bootstrap/fesm2015/ng-bootstrap.js");
    /* harmony import */


    var _interrogator_component__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(
    /*! ./interrogator.component */
    "./src/app/interrogator/interrogator.component.ts");
    /* harmony import */


    var _group_selector_component__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(
    /*! ./group-selector.component */
    "./src/app/interrogator/group-selector.component.ts");

    var InterrogatorModule = function InterrogatorModule() {
      _classCallCheck(this, InterrogatorModule);
    };

    InterrogatorModule = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["NgModule"])({
      imports: [_angular_common__WEBPACK_IMPORTED_MODULE_4__["CommonModule"], _angular_forms__WEBPACK_IMPORTED_MODULE_2__["FormsModule"], _angular_http__WEBPACK_IMPORTED_MODULE_3__["HttpModule"], _ng_bootstrap_ng_bootstrap__WEBPACK_IMPORTED_MODULE_5__["NgbModule"]],
      declarations: [_interrogator_component__WEBPACK_IMPORTED_MODULE_6__["InterrogatorComponent"], _group_selector_component__WEBPACK_IMPORTED_MODULE_7__["GroupSelectorComponent"]],
      exports: [_interrogator_component__WEBPACK_IMPORTED_MODULE_6__["InterrogatorComponent"], _group_selector_component__WEBPACK_IMPORTED_MODULE_7__["GroupSelectorComponent"], _ng_bootstrap_ng_bootstrap__WEBPACK_IMPORTED_MODULE_5__["NgbModule"]],
      entryComponents: []
    })], InterrogatorModule);
    /***/
  },

  /***/
  "./src/app/interrogator/show-phrases/show-phrases.component.css":
  /*!**********************************************************************!*\
    !*** ./src/app/interrogator/show-phrases/show-phrases.component.css ***!
    \**********************************************************************/

  /*! exports provided: default */

  /***/
  function srcAppInterrogatorShowPhrasesShowPhrasesComponentCss(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony default export */


    __webpack_exports__["default"] = "\n/*# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IiIsImZpbGUiOiJzcmMvYXBwL2ludGVycm9nYXRvci9zaG93LXBocmFzZXMvc2hvdy1waHJhc2VzLmNvbXBvbmVudC5jc3MifQ== */";
    /***/
  },

  /***/
  "./src/app/interrogator/show-phrases/show-phrases.component.ts":
  /*!*********************************************************************!*\
    !*** ./src/app/interrogator/show-phrases/show-phrases.component.ts ***!
    \*********************************************************************/

  /*! exports provided: ShowPhrasesComponent */

  /***/
  function srcAppInterrogatorShowPhrasesShowPhrasesComponentTs(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "ShowPhrasesComponent", function () {
      return ShowPhrasesComponent;
    });
    /* harmony import */


    var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
    /*! tslib */
    "./node_modules/tslib/tslib.es6.js");
    /* harmony import */


    var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(
    /*! @angular/core */
    "./node_modules/@angular/core/fesm2015/core.js");
    /* harmony import */


    var _angular_router__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(
    /*! @angular/router */
    "./node_modules/@angular/router/fesm2015/router.js");
    /* harmony import */


    var rxjs_operators__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(
    /*! rxjs/operators */
    "./node_modules/rxjs/_esm2015/operators/index.js");
    /* harmony import */


    var src_app_services_word_service__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(
    /*! src/app/services/word-service */
    "./src/app/services/word-service.ts");
    /* harmony import */


    var _guessed_word_converter__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(
    /*! ../guessed-word-converter */
    "./src/app/interrogator/guessed-word-converter.ts");

    var ShowPhrasesComponent =
    /*#__PURE__*/
    function () {
      function ShowPhrasesComponent(wordService, route, router) {
        _classCallCheck(this, ShowPhrasesComponent);

        this.wordService = wordService;
        this.route = route;
        this.router = router;
        this.words = null;
      }

      _createClass(ShowPhrasesComponent, [{
        key: "ngOnInit",
        value: function ngOnInit() {
          var _this7 = this;

          this.route.paramMap.subscribe(function (params) {
            _this7.key = params.get('id');
          });
          this.route.paramMap.pipe(Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_3__["switchMap"])(function (params) {
            return _this7.wordService.getWords(params.get('id'));
          })).subscribe(function (words) {
            _this7.words = new _guessed_word_converter__WEBPACK_IMPORTED_MODULE_5__["GuessedWordConverter"]().convertToGuessed(words);

            if (_this7.words != null) {
              _this7.wordsDisplayed = new Array(_this7.words.length);

              for (var index = 0; index < _this7.wordsDisplayed.length; index++) {
                _this7.wordsDisplayed[index] = true;
              }
            }
          });
        }
      }, {
        key: "interrogate",
        value: function interrogate() {
          this.router.navigate(['/interrogator', this.key]);
        }
      }, {
        key: "interrogateHere",
        value: function interrogateHere() {
          for (var index = 0; index < this.wordsDisplayed.length; index++) {
            this.wordsDisplayed[index] = false;
          }
        }
      }, {
        key: "display",
        value: function display(i) {
          this.wordsDisplayed[i] = true;
        }
      }, {
        key: "addNew",
        value: function addNew() {
          this.router.navigate(['/admin/addUnitContent', this.key]);
        }
      }]);

      return ShowPhrasesComponent;
    }();

    ShowPhrasesComponent.ctorParameters = function () {
      return [{
        type: src_app_services_word_service__WEBPACK_IMPORTED_MODULE_4__["WordService"]
      }, {
        type: _angular_router__WEBPACK_IMPORTED_MODULE_2__["ActivatedRoute"]
      }, {
        type: _angular_router__WEBPACK_IMPORTED_MODULE_2__["Router"]
      }];
    };

    ShowPhrasesComponent = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Component"])({
      selector: 'app-show-phrases',
      template: tslib__WEBPACK_IMPORTED_MODULE_0__["__importDefault"](__webpack_require__(
      /*! raw-loader!./show-phrases.component.html */
      "./node_modules/raw-loader/dist/cjs.js!./src/app/interrogator/show-phrases/show-phrases.component.html")).default,
      styles: [tslib__WEBPACK_IMPORTED_MODULE_0__["__importDefault"](__webpack_require__(
      /*! ./show-phrases.component.css */
      "./src/app/interrogator/show-phrases/show-phrases.component.css")).default]
    })], ShowPhrasesComponent);
    /***/
  },

  /***/
  "./src/app/models/guessed-word.ts":
  /*!****************************************!*\
    !*** ./src/app/models/guessed-word.ts ***!
    \****************************************/

  /*! exports provided: GuessedWord */

  /***/
  function srcAppModelsGuessedWordTs(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "GuessedWord", function () {
      return GuessedWord;
    });
    /* harmony import */


    var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
    /*! tslib */
    "./node_modules/tslib/tslib.es6.js");

    var GuessedWord =
    /*#__PURE__*/
    function () {
      function GuessedWord() {
        _classCallCheck(this, GuessedWord);

        this.lastAnswerWrong = false;
        this.wrongAnswerNumber = 0;
        this.correctAnswerNumber = 0;
      }

      _createClass(GuessedWord, [{
        key: "getWrongAnswerNumber",
        value: function getWrongAnswerNumber() {
          return this.wrongAnswerNumber;
        }
      }, {
        key: "incrementWrongAnswer",
        value: function incrementWrongAnswer() {
          this.wrongAnswerNumber++;
          this.lastAnswerWrong = true;
        }
      }, {
        key: "incrementCorrectAnswer",
        value: function incrementCorrectAnswer() {
          this.correctAnswerNumber++;
          this.lastAnswerWrong = false;
        }
      }]);

      return GuessedWord;
    }();
    /***/

  },

  /***/
  "./src/app/models/phrase.ts":
  /*!**********************************!*\
    !*** ./src/app/models/phrase.ts ***!
    \**********************************/

  /*! exports provided: Phrase */

  /***/
  function srcAppModelsPhraseTs(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "Phrase", function () {
      return Phrase;
    });
    /* harmony import */


    var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
    /*! tslib */
    "./node_modules/tslib/tslib.es6.js");

    var Phrase = function Phrase(phrase, translationId) {
      _classCallCheck(this, Phrase);

      this.phrase = phrase;
      this.translationId = translationId;
    };
    /***/

  },

  /***/
  "./src/app/models/translation-to-save.ts":
  /*!***********************************************!*\
    !*** ./src/app/models/translation-to-save.ts ***!
    \***********************************************/

  /*! exports provided: TranslationToSave */

  /***/
  function srcAppModelsTranslationToSaveTs(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "TranslationToSave", function () {
      return TranslationToSave;
    });
    /* harmony import */


    var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
    /*! tslib */
    "./node_modules/tslib/tslib.es6.js");

    var TranslationToSave = function TranslationToSave(id, from, to, example, translatedExample) {
      _classCallCheck(this, TranslationToSave);

      this.id = id;
      this.from = from;
      this.to = to;
      this.example = example;
      this.translatedExample = translatedExample;
    };
    /***/

  },

  /***/
  "./src/app/models/word.ts":
  /*!********************************!*\
    !*** ./src/app/models/word.ts ***!
    \********************************/

  /*! exports provided: Word */

  /***/
  function srcAppModelsWordTs(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "Word", function () {
      return Word;
    });
    /* harmony import */


    var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
    /*! tslib */
    "./node_modules/tslib/tslib.es6.js");

    var Word = function Word(id, from, to, example, translatedExample) {
      _classCallCheck(this, Word);

      this.id = id;
      this.from = from;
      this.to = to;
      this.example = example;
      this.translatedExample = translatedExample;
    };
    /***/

  },

  /***/
  "./src/app/services/word-service.ts":
  /*!******************************************!*\
    !*** ./src/app/services/word-service.ts ***!
    \******************************************/

  /*! exports provided: WordService */

  /***/
  function srcAppServicesWordServiceTs(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "WordService", function () {
      return WordService;
    });
    /* harmony import */


    var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
    /*! tslib */
    "./node_modules/tslib/tslib.es6.js");
    /* harmony import */


    var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(
    /*! @angular/core */
    "./node_modules/@angular/core/fesm2015/core.js");
    /* harmony import */


    var _angular_http__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(
    /*! @angular/http */
    "./node_modules/@angular/http/fesm2015/http.js");

    var WordService =
    /*#__PURE__*/
    function () {
      function WordService(http) {
        _classCallCheck(this, WordService);

        this.http = http;
      }

      _createClass(WordService, [{
        key: "getWords",
        value: function getWords(key) {
          return tslib__WEBPACK_IMPORTED_MODULE_0__["__awaiter"](this, void 0, void 0,
          /*#__PURE__*/
          regeneratorRuntime.mark(function _callee() {
            var res, json, unit;
            return regeneratorRuntime.wrap(function _callee$(_context) {
              while (1) {
                switch (_context.prev = _context.next) {
                  case 0:
                    _context.prev = 0;
                    _context.next = 3;
                    return this.http.get('http://localhost:3000/words/' + key).toPromise();

                  case 3:
                    res = _context.sent;
                    json = res != null ? res.json() : null;
                    unit = json != null ? json[0].content != null ? json[0].content : json[0] : null;
                    this.actualPhrases = unit != null ? unit.words : null;
                    return _context.abrupt("return", this.actualPhrases);

                  case 10:
                    _context.prev = 10;
                    _context.t0 = _context["catch"](0);
                    console.error(_context.t0);
                    return _context.abrupt("return", null);

                  case 14:
                  case "end":
                    return _context.stop();
                }
              }
            }, _callee, this, [[0, 10]]);
          }));
        }
      }, {
        key: "getActualWords",
        value: function getActualWords() {
          return this.actualPhrases;
        }
      }, {
        key: "getGroups",
        value: function getGroups() {
          return tslib__WEBPACK_IMPORTED_MODULE_0__["__awaiter"](this, void 0, void 0,
          /*#__PURE__*/
          regeneratorRuntime.mark(function _callee2() {
            var res;
            return regeneratorRuntime.wrap(function _callee2$(_context2) {
              while (1) {
                switch (_context2.prev = _context2.next) {
                  case 0:
                    _context2.prev = 0;
                    _context2.next = 3;
                    return this.http.get('http://localhost:3000/word_groups').toPromise();

                  case 3:
                    res = _context2.sent;
                    return _context2.abrupt("return", res.json()[0].groups);

                  case 7:
                    _context2.prev = 7;
                    _context2.t0 = _context2["catch"](0);
                    console.error(_context2.t0);
                    return _context2.abrupt("return", null);

                  case 11:
                  case "end":
                    return _context2.stop();
                }
              }
            }, _callee2, this, [[0, 7]]);
          }));
        }
      }, {
        key: "addUnitContent",
        value: function addUnitContent(translation) {
          return tslib__WEBPACK_IMPORTED_MODULE_0__["__awaiter"](this, void 0, void 0,
          /*#__PURE__*/
          regeneratorRuntime.mark(function _callee3() {
            var res;
            return regeneratorRuntime.wrap(function _callee3$(_context3) {
              while (1) {
                switch (_context3.prev = _context3.next) {
                  case 0:
                    _context3.prev = 0;
                    _context3.next = 3;
                    return this.http.put('http://localhost:3000/word/', translation).toPromise();

                  case 3:
                    res = _context3.sent;
                    return _context3.abrupt("return", res.json().unitContentId);

                  case 7:
                    _context3.prev = 7;
                    _context3.t0 = _context3["catch"](0);
                    console.error(_context3.t0);
                    return _context3.abrupt("return", null);

                  case 11:
                  case "end":
                    return _context3.stop();
                }
              }
            }, _callee3, this, [[0, 7]]);
          }));
        }
      }, {
        key: "removeUnitContent",
        value: function removeUnitContent(unitContentId) {
          return tslib__WEBPACK_IMPORTED_MODULE_0__["__awaiter"](this, void 0, void 0,
          /*#__PURE__*/
          regeneratorRuntime.mark(function _callee4() {
            var body;
            return regeneratorRuntime.wrap(function _callee4$(_context4) {
              while (1) {
                switch (_context4.prev = _context4.next) {
                  case 0:
                    _context4.prev = 0;
                    body = {
                      unitContentId: unitContentId
                    };
                    _context4.next = 4;
                    return this.http.put('http://localhost:3000/word/remove', body).toPromise();

                  case 4:
                    return _context4.abrupt("return", _context4.sent);

                  case 7:
                    _context4.prev = 7;
                    _context4.t0 = _context4["catch"](0);
                    console.error(_context4.t0);
                    return _context4.abrupt("return", null);

                  case 11:
                  case "end":
                    return _context4.stop();
                }
              }
            }, _callee4, this, [[0, 7]]);
          }));
        }
      }]);

      return WordService;
    }();

    WordService.ctorParameters = function () {
      return [{
        type: _angular_http__WEBPACK_IMPORTED_MODULE_2__["Http"]
      }];
    };

    WordService = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Injectable"])()], WordService);
    /***/
  },

  /***/
  "./src/assets/css/styles.css":
  /*!***********************************!*\
    !*** ./src/assets/css/styles.css ***!
    \***********************************/

  /*! exports provided: default */

  /***/
  function srcAssetsCssStylesCss(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony default export */


    __webpack_exports__["default"] = "body {\r\n    background: #D5D9DF;\r\n    color: #000000;\r\n}\r\n\r\n/*# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbInNyYy9hc3NldHMvY3NzL3N0eWxlcy5jc3MiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IkFBQUE7SUFDSSxtQkFBbUI7SUFDbkIsY0FBYztBQUNsQiIsImZpbGUiOiJzcmMvYXNzZXRzL2Nzcy9zdHlsZXMuY3NzIiwic291cmNlc0NvbnRlbnQiOlsiYm9keSB7XHJcbiAgICBiYWNrZ3JvdW5kOiAjRDVEOURGO1xyXG4gICAgY29sb3I6ICMwMDAwMDA7XHJcbn1cclxuIl19 */";
    /***/
  },

  /***/
  "./src/environments/environment.ts":
  /*!*****************************************!*\
    !*** ./src/environments/environment.ts ***!
    \*****************************************/

  /*! exports provided: environment */

  /***/
  function srcEnvironmentsEnvironmentTs(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony export (binding) */


    __webpack_require__.d(__webpack_exports__, "environment", function () {
      return environment;
    });
    /* harmony import */


    var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
    /*! tslib */
    "./node_modules/tslib/tslib.es6.js"); // This file can be replaced during build by using the `fileReplacements` array.
    // `ng build --prod` replaces `environment.ts` with `environment.prod.ts`.
    // The list of file replacements can be found in `angular.json`.


    var environment = {
      production: false
    };
    /*
     * For easier debugging in development mode, you can import the following file
     * to ignore zone related error stack frames such as `zone.run`, `zoneDelegate.invokeTask`.
     *
     * This import should be commented out in production mode because it will have a negative impact
     * on performance if an error is thrown.
     */
    // import 'zone.js/dist/zone-error';  // Included with Angular CLI.

    /***/
  },

  /***/
  "./src/main.ts":
  /*!*********************!*\
    !*** ./src/main.ts ***!
    \*********************/

  /*! no exports provided */

  /***/
  function srcMainTs(module, __webpack_exports__, __webpack_require__) {
    "use strict";

    __webpack_require__.r(__webpack_exports__);
    /* harmony import */


    var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
    /*! tslib */
    "./node_modules/tslib/tslib.es6.js");
    /* harmony import */


    var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(
    /*! @angular/core */
    "./node_modules/@angular/core/fesm2015/core.js");
    /* harmony import */


    var _angular_platform_browser_dynamic__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(
    /*! @angular/platform-browser-dynamic */
    "./node_modules/@angular/platform-browser-dynamic/fesm2015/platform-browser-dynamic.js");
    /* harmony import */


    var _app_app_module__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(
    /*! ./app/app.module */
    "./src/app/app.module.ts");
    /* harmony import */


    var _environments_environment__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(
    /*! ./environments/environment */
    "./src/environments/environment.ts");

    if (_environments_environment__WEBPACK_IMPORTED_MODULE_4__["environment"].production) {
      Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["enableProdMode"])();
    }

    Object(_angular_platform_browser_dynamic__WEBPACK_IMPORTED_MODULE_2__["platformBrowserDynamic"])().bootstrapModule(_app_app_module__WEBPACK_IMPORTED_MODULE_3__["AppModule"]).catch(function (err) {
      return console.error(err);
    });
    /***/
  },

  /***/
  0:
  /*!***************************!*\
    !*** multi ./src/main.ts ***!
    \***************************/

  /*! no static exports found */

  /***/
  function _(module, exports, __webpack_require__) {
    module.exports = __webpack_require__(
    /*! c:\src\Otthon\interrogator-web\src\main.ts */
    "./src/main.ts");
    /***/
  }
}, [[0, "runtime", "vendor"]]]);
//# sourceMappingURL=main-es5.js.map