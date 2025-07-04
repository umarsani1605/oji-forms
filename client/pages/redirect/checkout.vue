<template>
  <div class="flex flex-col items-center justify-center min-h-screen gap-4">
    <Loader class="w-8 h-8 text-emerald-500" />
    <p class="text-gray-500">
      Preparing your checkout...
    </p>
  </div>
</template>

<script setup>
definePageMeta({
  middleware: 'auth'
})

const route = useRoute()

onMounted(async () => {
  const { plan, yearly, trial_duration, currency, name, email } = route.query
  
  if (!plan) {
    useAlert().error('Missing plan information')
    navigateTo({ name: 'pricing' })
    return
  }

  try {
    // Update customer details if provided
    if (name && email) {
      try {
        await opnFetch('subscription/update-customer-details', {
          method: 'PUT',
          body: { name, email }
        })
      } catch {
        useAlert().error('Failed to update customer details, but proceeding with checkout')
      }
    }

    // Get checkout URL
    const params = { trial_duration, currency }
    const { checkout_url } = await opnFetch(
      `/subscription/new/${plan}/${yearly === 'true' ? 'yearly' : 'monthly'}/checkout/with-trial?${new URLSearchParams(params)}`
    )
    
    if (!checkout_url) {
      throw new Error('No checkout URL returned')
    }

    // Log trial usage if applicable
    if (trial_duration) {
      useAmplitude().logEvent('extended_trial_used', { duration: trial_duration })
    }
    
    window.location.href = checkout_url
  } catch {
    useAlert().error('Unable to start checkout process. Please try again or contact support.')
    setTimeout(() => {
      navigateTo({ name: 'pricing' })
    }, 2000)
  }
})
</script> 