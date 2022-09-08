/*
Copyright (c) 2022, Shanan Dalton

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
3. Neither the name of Shanan Dalton nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY SHANAN DALTON AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL SHANAN DALTON OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
export default {
  start: (app) =>
    customElements.define(
      "transitions-transitions",
      class extends HTMLElement {
        constructor() {
          super();

          this._isShowing = this.isShowing || false;
          delete this.isShowing;

          this._classesToList = (classes) => {
            if (classes)
              return classes
                .split(" ")
                .filter((className) => className.trim().length >= 1);
          };

          this._enterTransitions = {
            enter: this._classesToList(this.getAttribute("enter")),
            enterFrom: this._classesToList(this.getAttribute("enter-from")),
            enterTo: this._classesToList(this.getAttribute("enter-to")),
          };

          this._leaveTransitions = {
            leave: this._classesToList(this.getAttribute("leave")),
            leaveFrom: this._classesToList(this.getAttribute("leave-from")),
            leaveTo: this._classesToList(this.getAttribute("leave-to")),
          };

          this._isTransitioning = false;
          this._onEnteredEnd = this._onEnteredEnd.bind(this);
          this._onLeavingEnd = this._onLeavingEnd.bind(this);
        }

        set isShowing(val) {
          this._isShowing = Boolean(val);

          if (this._isTransitioning) return;
          this._isTransitioning = true;

          if (this._isShowing) {
            this._transitionEnter();
          } else {
            this._transitionLeave();
          }
        }

        _transitionEnter() {
          this.addEventListener("transitionend", this._onEnteredEnd, {
            once: true,
          });

          this.classList.remove(...this._leaveTransitions.leave);
          this.classList.add(...this._enterTransitions.enter);
          this.classList.add(...this._enterTransitions.enterFrom);

          requestAnimationFrame(() => {
            this.classList.remove(...this._enterTransitions.enterFrom);
            this.classList.add(...this._enterTransitions.enterTo);
          });
        }

        _transitionLeave() {
          this.addEventListener("transitionend", this._onLeavingEnd, {
            once: true,
          });

          this.classList.remove(...this._enterTransitions.enter);
          this.classList.add(...this._leaveTransitions.leave);
          this.classList.add(...this._leaveTransitions.leaveFrom);

          requestAnimationFrame(() => {
            this.classList.remove(...this._leaveTransitions.leaveFrom);
            this.classList.add(...this._leaveTransitions.leaveTo);
          });
        }

        _onEnteredEnd(e) {
          this._isTransitioning = false;
          this.dispatchEvent(new CustomEvent("onEnter"));
        }

        _onLeavingEnd(e) {
          this._isTransitioning = false;
          this.dispatchEvent(new CustomEvent("onLeave"));
        }

        connectedCallback() {}

        disconnectedCallback() {
          this.removeEventListener("transitionend", this._onEnteredEnd);
          this.removeEventListener("transitionend", this._onLeavingEnd);
        }
      }
    ),
};