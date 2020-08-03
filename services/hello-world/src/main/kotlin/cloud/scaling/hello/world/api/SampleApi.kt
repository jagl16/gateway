package cloud.scaling.hello.world.api

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class SampleApi {
    @GetMapping("/")
    fun home(): String {
        return "Hi, welcome to the world."
    }
}
