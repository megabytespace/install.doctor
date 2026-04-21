import { Component, State, Prop, h, Build } from '@stencil/core';
import { ResponsiveContainer, Button } from 'ionic-ds-no-fonts';
import { LandingPageData } from 'src/store';
// import { Background } from '../assets/bg-3-only.svg';
// import { Background } from '../assets/bg-boxes.svg';

import { importResource } from '../../../utils/common';

declare let $: any;

@Component({
  tag: 'top-parallax',
  styleUrl: 'top-parallax.scss',
  scoped: true,
})
export class LandingPage {
  $shapes!: HTMLDivElement;
  libID = 'parallax-lib';

  @State() showEmailInput: boolean = false;
  @State() showCommunity: boolean = false;
  @Prop() data: typeof LandingPageData;
  isTouchscreen =
    'ontouchstart' in window ||
    navigator.maxTouchPoints > 0 ||
    (navigator as any).msMaxTouchPoints > 0 ||
    window.innerWidth < 1024;

  disconnectedCallback() {
    // this.parallaxInstance.distroy()
  }

  initParticles() {
    var RENDERER = {
      BASE_PARTICLE_COUNT: 14,
      WATCH_INTERVAL: 400,

      init: function () {
        this.setParameters();
        this.reconstructMethods();
        this.setup();
        this.bindEvent();
        this.render();
      },
      setParameters: function () {
        this.$window = $(window);
        this.$container = $('#homing-particles');
        this.$containerInside = $('#hightop');
        this.$canvas = $('<canvas />');
        this.context = this.$canvas.appendTo(this.$container).get(0).getContext('2d');
        this.particles = [];
        this.watchIds = [];
        this.gravity = { x: 0, y: 0, on: false, radius: 100, gravity: true };
      },
      setup: function () {
        this.particles.length = 0;
        this.watchIds.length = 0;
        this.width = this.$container.width();
        this.height = this.$container.height();
        this.$canvas.attr({ width: this.width, height: this.height });
        this.distance = Math.sqrt(Math.pow(this.width / 2, 2) + Math.pow(this.height / 2, 2));
        this.createParticles();
      },
      reconstructMethods: function () {
        this.watchWindowSize = this.watchWindowSize.bind(this);
        this.jdugeToStopResize = this.jdugeToStopResize.bind(this);
        this.render = this.render.bind(this);
      },
      createParticles: function () {
        for (
          var i = 0, count = ((((this.BASE_PARTICLE_COUNT * this.width) / 500) * this.height) / 500) | 0;
          i < count;
          i++
        ) {
          this.particles.push(new PARTICLE(this));
        }
      },
      watchWindowSize: function () {
        this.clearTimer();
        this.tmpWidth = this.$window.width();
        this.tmpHeight = this.$window.height();
        this.watchIds.push(setTimeout(this.jdugeToStopResize, this.WATCH_INTERVAL));
      },
      clearTimer: function () {
        while (this.watchIds.length > 0) {
          clearTimeout(this.watchIds.pop());
        }
      },
      jdugeToStopResize: function () {
        var width = this.$window.width(),
          height = this.$window.height(),
          stopped = width == this.tmpWidth && height == this.tmpHeight;

        this.tmpWidth = width;
        this.tmpHeight = height;

        if (stopped) {
          this.setup();
        }
      },
      bindEvent: function () {
        this.$window.on('resize', this.watchWindowSize);
        this.$containerInside.on('mousemove', this.controlForce.bind(this, true));
        this.$containerInside.on('mouseleave', this.controlForce.bind(this, false));
      },
      controlForce: function (on, event) {
        this.gravity.on = on;

        if (!on) {
          return;
        }
        var offset = this.$container.offset();
        this.gravity.x = event.clientX - offset.left + this.$window.scrollLeft();
        this.gravity.y = event.clientY - offset.top + this.$window.scrollTop();
      },
      render: function () {
        requestAnimationFrame(this.render);

        var context = this.context;
        context.save();
        context.fillStyle = 'hsla(0, 0%, 0%, 0.3)';
        context.fillRect(0, 0, this.width, this.height);
        context.globalCompositeOperation = 'lighter';

        for (var i = 0, particles = this.particles, gravity = this.gravity, count = particles.length; i < count; i++) {
          var particle = particles[i];

          for (var j = i + 1; j < count; j++) {
            particle.checkForce(context, particles[j]);
          }
          particle.checkForce(context, gravity);
          particle.render(context);
        }
        context.restore();
      },
    };
    var PARTICLE = function (renderer) {
      this.renderer = renderer;
      this.init();
    };
    PARTICLE.prototype = {
      THRESHOLD: 100,
      SPRING_AMOUNT: 0.001,
      LIMIT_RATE: 0.2,
      GRAVIY_MAGINIFICATION: 10,

      init: function () {
        this.radius = this.getRandomValue(5, 15);
        this.x =
          this.getRandomValue(-this.renderer.width * this.LIMIT_RATE, this.renderer.width * (1 + this.LIMIT_RATE)) | 0;
        this.y =
          this.getRandomValue(-this.renderer.width * this.LIMIT_RATE, this.renderer.height * (1 + this.LIMIT_RATE)) | 0;
        this.vx = this.getRandomValue(-3, 3);
        this.vy = this.getRandomValue(-3, 3);
        this.ax = 0;
        this.ay = 0;
        this.gravity = false;
        this.transformShape();
      },
      getRandomValue: function (min, max) {
        return min + (max - min) * Math.random();
      },
      transformShape: function () {
        var velocity = Math.sqrt(this.vx * this.vx + this.vy * this.vy);
        this.scale = 1 - velocity / 15;
        this.hue = (180 + velocity * 12) % 360 | 0;
      },
      checkForce: function (context, particle) {
        if (particle.gravity && !particle.on) {
          return;
        }
        var dx = particle.x - this.x,
          dy = particle.y - this.y,
          distance = Math.sqrt(dx * dx + dy * dy),
          magnification = particle.gravity ? this.GRAVIY_MAGINIFICATION : 1;

        if (distance > this.THRESHOLD * magnification) {
          return;
        }
        var rate = this.SPRING_AMOUNT / magnification / (this.radius + particle.radius);
        this.ax = dx * rate * particle.radius;
        this.ay = dy * rate * particle.radius;

        if (!particle.gravity) {
          particle.ax = -dx * rate * this.radius;
          particle.ay = -dy * rate * this.radius;
        }
        if (distance > this.THRESHOLD * (particle.gravity ? 2 : 1)) {
          return;
        }
        context.lineWidth = particle.gravity ? 0.5 : 3;
        context.strokeStyle =
          'hsla(' + this.hue + ', 40%, 30%, ' + Math.abs(this.THRESHOLD - distance) / this.THRESHOLD + ')';
        context.beginPath();
        context.moveTo(this.x, this.y);
        context.lineTo(particle.x, particle.y);
        context.stroke();
      },
      render: function (context) {
        context.save();
        context.fillStyle = 'hsl(' + this.hue + ', 80%, 20%)';
        context.translate(this.x, this.y);
        context.rotate(Math.atan2(this.vy, this.vx) + Math.PI / 2);
        context.scale(this.scale, 1);
        context.beginPath();
        context.arc(0, 0, this.radius, 0, Math.PI * 2, false);
        context.fill();
        context.restore();

        this.x += this.vx;
        this.y += this.vy;
        this.vx += this.ax;
        this.vy += this.ay;

        if (
          (this.x < -this.radius && this.vx < 0) ||
          (this.x > this.renderer.width + this.radius && this.vx > 0) ||
          (this.y < -this.radius && this.vy < 0) ||
          (this.y > this.renderer.height + this.radius && this.vy > 0)
        ) {
          var theta = this.getRandomValue(0, Math.PI * 2),
            sin = Math.sin(theta),
            cos = Math.cos(theta),
            velocity = this.getRandomValue(-3, 3);

          this.x = -(this.renderer.distance + this.radius) * cos + this.renderer.width / 2;
          this.y = -(this.renderer.distance + this.radius) * sin + this.renderer.height / 2;
          this.vx = velocity * cos;
          this.vy = velocity * sin;
        }
        this.transformShape();
      },
    };
    $(function () {
      RENDERER.init();
    });
  }
  componentDidLoad() {
    if (!(window as any).jQueryLoaded) {
      if (Build.isServer) return;
      (window as any).jQueryLoaded = true;
      importResource({ propertyName: 'jquery', link: '/assets/js/jquery-slider.min.js', async: true }, () => {
        this.initParticles();
      });
    } else {
      this.initParticles();
    }
  }

  showEmail(e) {
    if (!this.showCommunity) {
      e.preventDefault();
      this.showEmailInput = true;
      const parallaxInput = document.getElementById('parallax-input');
      if (parallaxInput) {
        parallaxInput.focus();
      }
    }
  }

  inputBlur(ev) {
    this.showEmailInput = false;
  }

  scrollWelcome(ev) {
    const startEl = document.getElementById('welcome');
    setTimeout(() => {
      if (startEl) {
        startEl.scrollIntoView({ behavior: 'smooth' });
        setTimeout(() => {
          startEl.scrollIntoView({ behavior: 'smooth' });
        }, 667);
      }
    }, 667);
  }

  render() {
    return (
      <section id="hightop">
        <div id="homing-particles" class="section-overlay"></div>
        <ResponsiveContainer>
          <h1 class="parallax-header">
            <div class="reveal step-1 inline-flex">
              Desktop-<div class="underlined-header ascode">as-Code</div>,
            </div>
            <div class="reveal step-2">Batteries Included</div>
          </h1>
          <p class="parallax-header reveal step-3">
            Say goodbye to post-reformat headaches with Install Doctor! Restore your desktop in minutes using a simple one-liner, powered by your own secure git-stored config.
          </p>
          <div class="btns">
            <Button
              class="reveal step-4"
              kind="round"
              color="indigo"
              variation="light"
              href={this.showCommunity ? '/community' : ''}
              onClick={(e) => this.showEmail(e)}
              anchor={true}
            >
              {this.showCommunity ? 'Join Community' : 'Get Beta Access'} <span>{'->'}</span>
            </Button>
            <Button
              class="reveal step-5"
              kind="round"
              color="indigo"
              href="#welcome"
              onClick={(ev) => {
                this.scrollWelcome(ev);
              }}
              rel="noopener"
              anchor={true}
            >
              Learn More <span>{'->'}</span>
            </Button>
            <newsletter-signup-parallax
              defaults={this.data.defaults}
              onSubmissionSuccess={() => {
                this.showCommunity = true;
              }}
              onEmailInputBlur={(ev) => {
                this.inputBlur(ev);
              }}
              class={{
                open: this.showEmailInput,
              }}
            />
          </div>
        </ResponsiveContainer>
      </section>
    );
  }
}
