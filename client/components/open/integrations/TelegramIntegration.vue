<template>
  <IntegrationWrapper
    v-model="props.integrationData"
    :integration="props.integration"
    :form="form"
  >
    <div class="mb-4">
      <p class="text-gray-500 mb-4">
        Receive Telegram messages on each form submission.
      </p>
      <template v-if="providers.length">
        <FlatSelectInput
          v-model="integrationData.oauth_id"
          name="provider"
          :options="providers"
          display-key="name"
          option-key="id"
          emit-key="id"
          :required="true"
          label="Select Telegram Account"
        >
          <template #help>
            <InputHelp>
              <span>
                <NuxtLink
                  class="text-emerald-500"
                  :to="{ name: 'settings-connections' }"
                >
                  Click here
                </NuxtLink>
                to connect another account.
              </span>
            </InputHelp>
          </template>
        </FlatSelectInput>

        <h4 class="font-bold mt-4">
          Telegram message actions
        </h4>
        <notifications-message-actions
          v-model="integrationData.settings"
          :form="form"
        />
      </template>

      <v-button
        v-else
        color="white"
        :loading="providersStore.loading"
        @click.prevent="connect"
      >
        Connect Telegram account
      </v-button>
    </div>
  </IntegrationWrapper>
</template>

<script setup>
import FlatSelectInput from '~/components/forms/FlatSelectInput.vue'
import IntegrationWrapper from './components/IntegrationWrapper.vue'
import NotificationsMessageActions from './components/NotificationsMessageActions.vue'

const props = defineProps({
  integration: { type: Object, required: true },
  form: { type: Object, required: true },
  integrationData: { type: Object, required: true },
  formIntegrationId: { type: Number, required: false, default: null }
})

const providersStore = useOAuthProvidersStore()
const providers = computed(() => providersStore.getAll.filter(provider => provider.provider == 'telegram'))

function connect () {
  useRouter().push({ name: 'settings-connections' })
}
</script> 