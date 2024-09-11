<template>
  <div id="app">
    <h1>Library Manager</h1>
    <Books />
  </div>
</template>

<script>
import Books from "./components/books.vue";

export default {
  components: {
    Books
  },
  data: function () {}
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
