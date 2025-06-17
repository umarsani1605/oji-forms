<template>
  <div>
    <forgot-password-modal
      :show="showForgotModal"
      @close="showForgotModal = false"
    />

    <form
      method="POST"
      class="mt-4 space-y-4"
      @submit.prevent="login"
      @keydown="form.onKeydown($event)"
    >
      <!-- Email -->
      <text-input
        name="email"
        :form="form"
        label="Email"
        :required="true"
        placeholder="Email"
      />

      <!-- Password -->
      <text-input
        native-type="password"
        placeholder="Password"
        name="password"
        :form="form"
        label="Password"
        :required="true"
      />

      <!-- Remember Me -->
      <div class="relative flex items-center mt-3">
        <CheckboxInput
          v-model="remember"
          class="w-full md:w-1/2"
          name="remember"
          size="small"
          label="Remember me"
        />
      </div>

      <!-- Submit Button -->
      <v-button
        class="w-full flex mt-2"
        :loading="form.busy || loading"
      >
        Log in to continue
      </v-button>

      <v-button
        v-if="useFeatureFlag('services.google.auth')"
        native-type="button"
        color="white"
        class="space-x-4 mt-4 flex items-center w-full"
        :loading="false"
        @click.prevent="signInwithGoogle"
      >
        <Icon
          name="devicon:google"
          class="w-4 h-4"
        />
        <span class="mx-2">Sign in with Google</span>
      </v-button>
    </form>
  </div>
</template>

<script>
import ForgotPasswordModal from "../ForgotPasswordModal.vue"
import { WindowMessageTypes } from "~/composables/useWindowMessage"

export default {
  name: "LoginForm",
  components: {
    ForgotPasswordModal,
  },
  props: {
    isQuick: {
      type: Boolean,
      required: false,
      default: false,
    },
  },

  emits: ['openRegister'],
  setup() {
    return {
      appStore: useAppStore(),
      authStore: useAuthStore(),
      formsStore: useFormsStore(),
      workspaceStore: useWorkspacesStore(),
      providersStore: useOAuthProvidersStore()
    }
  },

  data: () => ({
    form: useForm({
      email: "",
      password: "",
    }),
    loading: false,
    remember: false,
    showForgotModal: false,
  }),

  computed: {},

  mounted() {
    // Use the window message composable
    const windowMessage = useWindowMessage(WindowMessageTypes.LOGIN_COMPLETE)
    
    // Listen for login complete messages
    windowMessage.listen(() => {
      this.redirect()
    })
  },

  methods: {
    async login() {
      this.loading = true
      const auth = useAuth()
      
      try {
        await auth.loginWithCredentials(this.form, this.remember)
        this.redirect()
      } catch (error) {
        if (error.response?._data?.message == "You must change your credentials when in self host mode") {
          this.redirect()
        }
      } finally {
        this.loading = false
      }
    },

    redirect() {
      if (this.isQuick) {
        // Use window message instead of event
        const afterLoginMessage = useWindowMessage(WindowMessageTypes.AFTER_LOGIN)
        afterLoginMessage.send(window)
        return
      }

      const intendedUrlCookie = useCookie("intended_url")
      const router = useRouter()

      if (intendedUrlCookie.value) {
        router.push({ path: intendedUrlCookie.value })
        useCookie("intended_url").value = null
      } else {
        router.push({ name: "home" })
      }
    },
    signInwithGoogle() {
      this.providersStore.guestConnect('google', true)
    }
  },
}
</script>
