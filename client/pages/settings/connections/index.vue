<template>
  <div>
    <div class="flex items-center gap-4 flex-wrap">
      <div class="flex-grow">
        <h3 class="font-semibold text-2xl text-gray-900">
          Connections
        </h3>
        <small class="text-gray-600">Manage your external connections.</small>
      </div>
      <UButton
        label="Connect account"
        icon="i-heroicons-plus"
        color="emerald"
        :loading="loading"
        @click="providerModal = true"
      />
    </div>

    <div
      v-if="loading"
      class="w-full text-emerald-500 text-center"
    >
      <Loader class="h-10 w-10 p-5" />
    </div>

    <div class="py-6">
      <ProviderCard
        v-for="provider in providers"
        :key="provider.id"
        :provider="provider"
      />
    </div>

    <ProviderModal
      :show="providerModal"
      @close="providerModal = false"
    />
  </div>
</template>

<script setup>
import { computed, ref, onMounted } from 'vue'
import { useOAuthProvidersStore } from '~/stores/oauth_providers'
import { useOpnSeoMeta } from '~/composables/useOpnSeoMeta' 

useOpnSeoMeta({
  title: "Connections",
})

definePageMeta({
  middleware: "auth",
})

const providerModal = ref(false)
const providersStore = useOAuthProvidersStore()
const providers = computed(() => providersStore.getAll)
const loading = computed(() => providersStore.loading)

onMounted(() => {
  providersStore.fetchOAuthProviders()
})
</script> 