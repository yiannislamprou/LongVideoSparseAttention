#!/bin/bash

# Function to run benchmark
run_benchmark() {
    local config_type=$1 # "base" or "lvsa"
    if [ "$config_type" = "lvsa" ]; then
        export DIFFUSION_ATTENTION_BACKEND=LVSA
        export LVSA_BACKEND=sdpa
        export LVSA_SCHEDULE_START=0
        export LVSA_SCHEDULE_END=0
        export LVSA_N_FIRST_FRAMES=0
        export LVSA_ROTATE_KEYFRAMES=true
        export LVSA_TOTAL_STEPS=80  # double the num-inference-steps
        #export LVSA_STEP_TIME_LOG=1
        #export LVSA_MEM_LOG=1
        #export LVSA_MASK_LOG=40-70
        echo "Running vllm-omni experiments: LVSA"
    else
        unset DIFFUSION_ATTENTION_BACKEND
        unset LVSA_BACKEND
        echo "Running vllm-omni experiments: BASE"
    fi
    
    # Fixed array of example prompts
    local prompt_list=(
     #"A golden retriever with thick lustrous fur bounds joyfully through an ancient temperate forest during the golden hour of late afternoon, its powerful legs propelling it over a carpet of fallen autumn leaves in shades of burnt sienna, deep amber, and ochre. Sunlight filters through the high canopy of towering oak and beech trees in dramatic shafts, creating a chiaroscuro effect of warm golden light alternating with deep cool shadows. The dog's ears flap with each athletic stride, tongue lolling out in evident delight, eyes bright with the unselfconscious pleasure of pure motion. Pollen, dust motes, and tiny insects swirl through the rays of light, each one rendered as a delicate sparkle. The camera tracks the dog at a low angle in a smooth lateral dolly shot, paralleling its trajectory and occasionally tilting up to catch the cathedral-like architecture of the ancient trees. Moss-covered fallen logs, mushroom clusters, ferns, and small clusters of late-season wildflowers in white and lavender punctuate the path, each disturbed slightly by the dog's passage. Light mist hovers in low pockets close to the forest floor, catching the warm light and softening the depth. The atmosphere is one of vibrant aliveness, nostalgia, and unrestrained natural joy. The depth of field is shallow, keeping the dog in razor focus while the background dissolves into painterly bokeh of greens, golds, and rich earth tones. The color grading is warm but naturalistic, with rich highlight roll-off and gentle film-emulated contrast. Birds occasionally flutter at the edges of frame, drawn by the commotion. The pacing of motion is brisk but unhurried, the kind of effortless animal grace that comes from a creature in its element. Shot on a vintage cinema lens with subtle vignetting, slight chromatic aberration on highlights, and a hint of film grain. The overall mood evokes nature cinematography in the tradition of Terrence Malick, with reverence for the play of light through leaves and the dignity of an animal at home in the wild."
     #"A sleek long-haired tortoiseshell cat sits regally on a wooden windowsill, watching rain stream down the glass in glistening rivulets. The cat is rendered in exquisite detail every individual hair catching subtle light, eyes a luminous amber-green narrowed in feline contemplation, tail curled in a graceful arc around its body. The setting is the interior of a cozy attic apartment in autumn, with worn hardwood floors, a vintage tea kettle on a cast iron stove, framed botanical prints on the walls, and shelves overflowing with leather-bound books and small house plants. Beyond the rain-streaked window lies a moody urban scene at twilight: cobblestone streets glistening wet, blurred amber streetlamps creating pools of warm light, the silhouettes of Edwardian rowhouses receding into atmospheric perspective, and the warm glow of distant cafe windows. The rain itself falls in fine sheets, with individual droplets traceable on the glass, some merging into larger streams that wend their way down the pane. The cat occasionally flicks an ear in response to a sound only it can hear, or its whiskers twitch as a particularly heavy drop hits the window. Steam curls visibly from a porcelain teacup on the windowsill beside the cat. The lighting is moody and atmospheric predominantly cool blues and greys outside contrasted with the warm amber tungsten interior, creating a chiaroscuro that emphasizes the cat's role as a silent observer between two worlds. The camera frames the cat in a medium close-up, slowly pushing in over the duration of the shot, the focus shifting subtly between the cat's eyes and the patterns of rain on the glass. The aesthetic recalls Dutch interior painting, especially Vermeer, with its careful attention to light falling on textured surfaces. Soft jazz or melancholy piano music might be implied by the mood. Color palette is autumnal rust, amber, deep teal, and warm grey. The atmosphere is contemplative, peaceful, almost meditative. Slight film grain and gentle bloom on highlights enhance the painterly quality. Shot on a vintage anamorphic lens for slight oval bokeh in distant lights, evoking the romantic urban photography of Saul Leiter."
     #"Massive ocean waves crash against a rugged coastline of dark volcanic rock at the precise moment of sunset, the scene saturated in dramatic golden and crimson light. Waves rise to towering heights before curling and breaking with explosive force, sending plumes of white spray and crystalline droplets fifty feet into the air. Each droplet catches the sunset light, refracting it into miniature suns suspended in mid-air. The sea is a churning chaos of deep teal and emerald in the troughs, with foaming white caps glowing pink-orange in the dying light. Black basalt rocks, slick with seawater, anchor the foreground, their sharp edges glistening with brine and decorated with patches of green algae and small clusters of mussels. Behind, the cliffs rise dramatically, etched with horizontal striations of geological history, their tops crowned with tough wind-bent grasses silhouetted against the sky. The horizon stretches infinite, the sun a perfect blood-orange disk just beginning to touch the water's edge, sending a column of molten gold across the sea directly toward the viewer. High clouds catch the sunset in elaborate pink, magenta, and violet formations, while lower stratus drift moodily across the upper sky. Seabirds wheel and dive through the spray, their wings catching glints of sunset. The camera is positioned at a low angle on the cliff edge, executing a slow rotational orbit that gradually reveals the dramatic vastness of the scene. The depth of field is deep, keeping both the immediate spray and the distant horizon in crisp focus. The motion is grand and elemental the slow majestic rhythm of waves, the explosive burst of spray, the gentle drift of clouds, the wheeling birds. The color palette is saturated and dramatic molten gold, deep teal, blood orange, basalt black, foam white. Cinematography is grand and operatic, with rich contrast and generous highlight roll-off. The mood is sublime humbling, awe-inspiring, contemplative natural spectacle that reminds the viewer of untamed power."
     #"A solitary figure in a long charcoal wool coat with the collar turned up walks slowly through a snowy European city street at night, hands buried in pockets, breath visible in the frigid air as small white puffs. Heavy snowflakes fall in lazy drifting patterns, illuminated dramatically as they pass through the warm amber pools of ornate cast-iron streetlamps spaced along the cobblestone street. The cobblestones are slick with fresh snow, footprints disappearing into the soft white blanket behind the walker. To either side of the street rise tall historic buildings neoclassical facades with wrought-iron balconies, leaded glass windows aglow with warm interior light, ornate stone carvings around doorways softened by accumulating snow. A few buildings sport festive wreaths or strings of warm white lights. The street curves gently into the distance, drawing the eye toward a distant cathedral spire silhouetted against the deep navy sky. A few other figures are visible in the far distance, bundled against the cold. An old-fashioned bicycle leans against a streetlamp, accumulating its own little drift of snow. The walker moves with measured pace, the kind of unhurried introspection that comes from a winter evening alone. Their long coat sways slightly with each step, head turning occasionally to take in the falling snow or a glowing window. The camera tracks the figure from a respectful distance at chest height, executing a slow lateral dolly with occasional gentle pans. The depth of field is moderate, isolating the figure while keeping the architectural beauty of the surroundings legible. Lighting is dramatic chiaroscuro pools of warm tungsten amber from the streetlamps and windows contrasted against the cool blue ambient light of falling snow at night. The breath puffs catch the lamplight beautifully. The color palette is restrained deep navy, warm amber, charcoal, snow white, with occasional pops of warm interior glow. The atmosphere is melancholy but beautiful solitude with dignity, the quiet poetry of a winter night in an old city. Slight film grain, generous highlight bloom, anamorphic lens flares from streetlamps."
     #"A vibrant tropical coral reef teems with life beneath the surface of a sun-dappled sea, captured in breathtaking detail and color. Schools of brilliant yellow and electric blue fish tangs, butterflyfish, parrotfish weave gracefully through forests of branching coral in shades of pink, purple, fluorescent green, and creamy beige. Each fish moves with perfect synchrony in its school, executing precise turns that shimmer with iridescence as scales catch the sunlight refracting through the water above. The reef is living architecture towering pillars of stony coral, delicate fan corals waving in the current, brain corals rendered in intricate convoluted patterns, anemones with pulsing tentacles in pale lavender and white. Smaller life is everywhere: tiny cleaner shrimp at coral-cleaning stations, hermit crabs scuttling across the sea floor, a curious moray eel poking its head from a crevice, a sea turtle gliding majestically through the upper frame on slow flipper strokes. The water is breathtakingly clear, with shafts of sunlight penetrating from the surface above in shifting columns that dance across the reef as the waves ripple overhead. Tiny particulates and plankton drift through the rays, each catching light like underwater stardust. The blue of the water shifts subtly from pale aquamarine above to deep indigo in the distant background, where the reef drops into mystery. A reef shark cruises silently in the far distance, sensed more than seen. The camera glides through the scene in a fluid weightless motion sometimes drifting alongside a school of fish, sometimes orbiting a striking coral formation, sometimes ascending to capture the dappled sunlight from below. The depth of field is moderate, keeping the immediate reef in sharp focus while distant elements soften atmospherically. Bubbles trail upward in silvery streams. The motion is fluid, three-dimensional, and continuous life moving in every direction. The color palette is rich and saturated cyan and indigo water, vibrant fish colors, the entire pastel and neon spectrum of living coral. Lighting is naturalistic but dramatic, with caustic patterns creating constant motion. The mood is wonder, abundance, the unfathomable beauty of marine biodiversity."
     #"Inside a colossal crystalline chamber that floats in a nebula of shimmering probabilities, a master weaver stands before a living tapestry not of thread but of vibrating, luminous strings, each one a fundamental force of the universe. The weaver's hands, adorned with gloves of condensed light, move with deliberate grace, plucking a cosmic string that resonates with a deep cello-like hum. The pluck creates a ripple that travels down the string, causing a burst of golden particles to coalesce into a slowly rotating double helix of a new DNA strand. In the background, other weavers perform similar tasks, their movements choreographed like a silent ballet; one weaves a cascade of blue water that defies gravity, another knots strands to form the intricate skeleton of a future tree. The entire scene is a symphony of creation, with each movement of the weavers generating tangible reality from the chaotic beauty of the quantum foam. The atmosphere is one of serene, immense power and profound focus. The lighting is soft and diffuse, emanating from the strings and the nascent creations themselves, with deep blues and vibrant golds dominating the palette. The camera slowly orbits the central weaver, emphasizing the three-dimensional depth of the loom and the birth of complexity from simplicity."
     #"A circular, sun-drenched atelier has walls made of translucent, layered honeycomb panels that glow with a soft internal light. An elderly artisan with kind eyes and silver hair moves slowly through the space, which is filled with floating crystalline orbs, each containing a shimmering, captured memory suspended by thin, almost invisible filaments of light. The artisan gently cups a tarnished orb whose inner light flickers weakly. With a delicate brush whose bristles are made of focused sunlight, she carefully cleans the orb's surface, her strokes leaving trails of brightening light. As she works, the murky scene inside the orb, a childhood birthday party, clarifies, revealing laughing faces and the bright colors of balloons. A younger apprentice nearby practices by guiding a newly formed memory orb, a scene of a couple's first dance, into an ornate filigree frame made of solidified moonlight. The atmosphere is deeply peaceful and reverent, filled with the faint sound of a distant music box. The air shimmers with motes of dust that are actually particles of forgotten dreams. The camera focuses on the artisan's hands, the meticulous care in her movements, then pulls back to show the vast scale of the atelier, a library of lives being tenderly preserved."
     "A vast, cavernous space represents the inside of a human artery, with walls of pulsating organic tissue covered in intricate biological patterns that glow with a soft bioluminescence. Dozens of biomechanical nanorobots, resembling intricate cybernetic dragonflies, swarm in a highly coordinated dance around the framework of a futuristic medical implant. Their movements are swift and precise, welding glowing components with beams of concentrated proteins and aligning microscopic circuits. A central, larger robot, a foreman with multiple articulated arms, directs the flow of materials, which are delivered by smaller pod-like robots navigating through a fluid that looks like liquid silver. The environment is alive; the artery walls gently contract and expand while platelets and other cellular structures drift by like majestic whales in a cosmic sea. The lighting is an eerie mix of deep reds from the biological environment and the sharp electric blues and greens from the robots' welding tools and the half-finished device. The camera swoops through the chaotic yet ordered construction site, following a single component as it is passed from one robot to another, highlighting the incredible scale and complexity of this internal engineering marvel."
    )
    
    # Loop through prompts from the fixed array
    for prompt in "${prompt_list[@]}"; do
        prompt_id=$(echo "$prompt" | tr ' ' '_' | cut -c1-20)
        # Loop through different frame counts
        for frames in 161 321 481; do # 81 161 321 481
            export LVSA_TOTAL_LATENT_FRAMES=$(((frames - 1) / 4 + 1)) # only pertinent to LVSA; indifferent otherwise
            # Process each model with current frame count
            for model in "Wan2.2-T2V-A14B-Diffusers"; do # Wan2.1-T2V-1.3B-Diffusers Wan2.2-T2V-A14B-Diffusers Wan2.2-TI2V-5B-Diffusers
                # Set additional arguments for parallelism in Wan2.2-T2V-A14B-Diffusers
                additional_args=""
                if [ "$model" = "Wan2.2-T2V-A14B-Diffusers" ]; then
                    export MULTI_STREAM_MEMORY_REUSE=2
                    additional_args="--vae-use-slicing --vae-use-tiling --ulysses-degree 8" 
                    # to avoid OOM enable sequence parallelism: add use_hsdp=True in DiffusionParallelConfig in ./examples/offline_inference/text_to_video/text_to_video.py 
                else
                    unset MULTI_STREAM_MEMORY_REUSE
                fi

                # Extract version (2_2 or 2_1) and parameter size (14, 5, or 1.3)
                version=$(echo $model | sed 's/Wan\([0-9]\.[0-9]\)-.*/\1/' | tr '.' '_')
                size=$(echo $model | grep -oE '[0-9]+(\.[0-9]+)?B' | tr -d 'B')

                # Run text-to-video generation
                echo "Running ${prompt_id}_480p_${config_type}_${version}_${size}B_${frames}"
                args=(
                    --model "${MODEL_DIR:-/home/ioannis}/$model/"
                    --prompt "$prompt"
                    --negative-prompt "blurry, distorted, chaotic, dark shadows, grim atmosphere, broken objects, violent movement, dull colors, mundane reality, noise, grain, low resolution, sad emotions, destruction, primitive technology, biological decay, horror elements"
                    --height 480
                    --width 832 
                    --num-frames ${frames}
                    --num-inference-steps 40
                    --guidance-scale 4.0
                    --guidance-scale-high 4.0
                    #--cache-backend cache_dit
                    --fps 16
                    --seed 42
                    --flow-shift 12.0 # 12.0 for 480p, 5.0 for 720p
                    --boundary-ratio 0.875
                    --output ${prompt_id}_480p_${config_type}_${version}_${size}B_${frames}.mp4
                    ${additional_args}
                )
                python examples/offline_inference/text_to_video/text_to_video.py "${args[@]}" &> ${prompt_id}_480p_${config_type}_${version}_${size}B_${frames}.log
                grep "40/40" ${prompt_id}_480p_${config_type}_${version}_${size}B_${frames}.log
                grep "generation time" ${prompt_id}_480p_${config_type}_${version}_${size}B_${frames}.log
            done
        done
    done
}

# Main script with argument handling
case "${1:-}" in
    "base")
        run_benchmark "base"
        ;;
    "lvsa")
        run_benchmark "lvsa"
        ;;
    "all")
        run_benchmark "base"
        run_benchmark "lvsa"
        ;;
    *)
        echo "Usage: $0 {base|lvsa|all}"
        echo "  base - Run only base configuration benchmarks"
        echo "  lvsa - Run only LVSA configuration benchmarks"
        echo "  all  - Run both base and LVSA configurations"
        exit 1
        ;;
esac
