<template>
  <Teleport to="body">
    <transition @leave="onLeave">
      <div
        v-if="show"
        ref="backdrop"
        :class="[{ 'backdrop-blur-sm': backdropBlur }, twMerge('fixed z-40 top-0 inset-0 px-2 sm:px-4 flex items-top justify-center bg-gray-700/75 w-full h-screen overflow-y-scroll', $attrs.class)]"
        @click.self="close"
      >
        <div
          ref="content"
          class="self-start bg-white dark:bg-notion-dark w-full relative my-2 sm:my-6 rounded-xl shadow-xl"
          :class="maxWidthClass"
        >
          <div
            v-if="closeable"
            class="absolute top-4 right-4"
          >
            <button
              class="text-gray-500 hover:text-gray-900 cursor-pointer"
              @click="close()"
            >
              <svg
                class="h-6 w-6"
                viewBox="0 0 24 24"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  d="M18 6L6 18M6 6L18 18"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                />
              </svg>
            </button>
          </div>
          <div
            v-if="_has($slots, 'icon') || _has($slots, 'title')"
            class="flex border-b pb-4"
            :class="[
              {
                'flex-col sm:items-start': !compactHeader,
                'items-center justify-center py-6 gap-x-4': compactHeader,
              },
              headerInnerPadding,
            ]"
          >
            <div
              v-if="_has($slots, 'icon')"
              :class="{ 'w-full mb-4 flex justify-center': !compactHeader }"
            >
              <div
                class="w-14 h-14 rounded-full flex justify-center items-center"
                :class="'bg-' + iconColor + '-100 text-' + iconColor + '-600'"
              >
                <slot name="icon" />
              </div>
            </div>
            <div
              class="mt-3 text-center sm:mt-0"
              :class="{ 'w-full': !compactHeader }"
            >
              <h2
                v-if="_has($slots, 'title')"
                class="text-2xl font-semibold text-center text-gray-900"
              >
                <slot name="title" />
              </h2>
            </div>
          </div>

          <div
            class="w-full"
            :class="innerPadding"
          >
            <slot />
          </div>

          <div
            v-if="_has($slots, 'footer')"
            class="bg-gray-50 border-t rounded-b-xl text-right"
            :class="footerInnerPadding"
          >
            <slot name="footer" />
          </div>
        </div>
      </div>
    </transition>
  </Teleport>
</template>

<script setup>
import { watch } from 'vue'
import { default as _has } from 'lodash/has'
import {twMerge} from 'tailwind-merge'

const props = defineProps({
  show: {
    type: Boolean,
    default: false
  },
  backdropBlur: {
    type: Boolean,
    default: false
  },
  iconColor: {
    type: String,
    default: 'emerald'
  },
  maxWidth: {
    type: String,
    default: '2xl'
  },
  innerPadding: {
    type: String,
    default: 'p-6'
  },
  headerInnerPadding: {
    type: String,
    default: 'p-6'
  },
  footerInnerPadding: {
    type: String,
    default: 'p-6'
  },
  closeable: {
    type: Boolean,
    default: true
  },
  compactHeader: {
    default: false,
    type: Boolean
  }
})

const emit = defineEmits(['close'])

useHead({
  bodyAttrs: computed(() => {
    return {
      class: {
        'overflow-hidden': props.show
      }
    }
  })
})

const closeOnEscape = (e) => {
  if (e.key === 'Escape' && props.show) {
    close()
  }
}

onMounted(() => {
  if (import.meta.server) return
  document.addEventListener('keydown', closeOnEscape)
  initMotions()
})

onBeforeUnmount(() => {
  if (import.meta.server) return
  document.removeEventListener('keydown', closeOnEscape)
})

const maxWidthClass = computed(() => {
  return {
    sm: 'sm:max-w-sm',
    md: 'sm:max-w-md',
    lg: 'sm:max-w-lg',
    xl: 'sm:max-w-xl',
    '2xl': 'max-w-2xl',
    'screen-lg': 'max-w-screen-lg'
  }[props.maxWidth]
})

const motionFadeIn = {
  initial: {
    opacity: 0,
    transition: {
      delay: 100,
      duration: 200,
      ease: 'easeIn'
    }
  },
  enter: {
    opacity: 1,
    transition: {
      duration: 200
    }
  }
}

const motionSlideBottom = {
  initial: {
    y: 150,
    opacity: 0,
    transition: {
      ease: 'easeIn',
      duration: 200
    }
  },
  enter: {
    y: 0,
    opacity: 1,
    transition: {
      duration: 250,
      ease: 'easeOut',
      delay: 100
    }
  }
}

const onLeave = (el, done) => {
  contentMotion.value.leave(() => {})
  backdropMotion.value.leave(done)
}

const close = () => {
  if (props.closeable) {
    emit('close')
  }
}

const backdrop = ref(null)
const content = ref(null)
const backdropMotion = ref(null)
const contentMotion = ref(null)

const initMotions = () => {
  if (props.show) {
    nextTick(() => {
      backdropMotion.value = useMotion(backdrop.value, motionFadeIn)
      contentMotion.value = useMotion(content.value, motionSlideBottom)
    })
  }
}

watch(() => props.show, initMotions)
</script>
